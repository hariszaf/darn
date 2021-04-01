#!/usr/bin/python

# developed by: Haris Zafeiropoulos
# in the framework of the DARN project

import sys, json

###################################################################
# PART A: Parse per query gappa output to build Krona input
###################################################################

input_file = open("darn_gappa_assign_per_query.tsv", "r")

# Two dictionaries will be built
# One for the domains of each query {'Query78': ['Bacteria'], 'Query79': ['Archaea'], 'Query76': ['Bacteria'], ... }
# And a second one for the likelihood sums for each taxonomy: {'Eukaryota;Chlorophyta': 4.441, 'Eukaryota;Haptista;Haptophyta': 0.7416, ...}

domain_dict = {}
counter = 0 
lwr_dict = {}
counts_dict = {}

# Each line of the per_query is parsed to fill in the 2 dictionaries 
for line in input_file:

   # Keep the query id
   line = line.split("\t")
   query_id = line[0]

   # Check if it is actuall a query sequence; otherwise move to the next
   if "Query" not in query_id:
      continue

   else:

      # Keep the complete taxonomy and the domain of the query assignment
      taxonomy = line[-1]
      domain = taxonomy.split(";")[0]
      taxonomy = taxonomy[:-1]

      # Remove new line from domain if there
      if "\n" in domain:
         domain = domain[:-1]

      # Check if this is the first record for this query id and if yes, add a key-value pair with its domain as a list
      if query_id not in domain_dict.keys():
         domain_dict[query_id] = [domain]

      # Otherwise, just add the domain of this new record to the list
      else:
         domain_dict[query_id].append(domain)

      # Keep the LWR score of the record
      lwr = line[1]

      # And again, if this is the first record make a new pair 
      if taxonomy not in lwr_dict.keys():
         lwr_dict[taxonomy] = float(lwr)
      
      # This is critical!! Otherwise, we add this new likelihood value to the list
      else:
         lwr_dict[taxonomy] += float(lwr)

      # Likewise, count occurences
      if taxonomy not in counts_dict.keys():
         counts_dict[taxonomy] = 1.0
      else: 
         counts_dict[taxonomy] += 1.0

# Build likelihood krona profile 
lwr_krona_profile = open("darn_processed_lwr.profile", "w")
entries = []
for taxonomy, value in lwr_dict.items():

   taxonomy = taxonomy.split(";")
   layers = taxonomy[0]

   if len(layers) > 1:

      for level in taxonomy[1:]:
         layers += "\t" + level

   entry = (value, layers)
   entries.append(entry)


# Sort based on the taxonomy
entries.sort(key=lambda x:x[1])

# Write a file with all the entries 
for entry in entries:
   lwr_krona_profile.write(str(entry[0]) + "\t" + entry[1] + "\n")


# Likewise, for the counts 
counts_krona_profile = open("darn_processed_counts.profile", "w")
exact_counts = {}
for taxonomy, value in counts_dict.items():

   taxonomy = taxonomy.split(";")      # taxonomy is a LIST

   domain_check = taxonomy[0]

   if len(domain_check) > 1:

      domain = domain_check

      # Build taxonomy and add intra-taxonomy occurences
      for level in range(len(taxonomy)):

         if level == 0 :
            build_taxonomy = taxonomy[level]

            if len(taxonomy) == 1:
               if build_taxonomy not in exact_counts.keys():
                  exact_counts[build_taxonomy] = value
               else:
                  exact_counts[build_taxonomy] += value

            else:
               if build_taxonomy not in exact_counts.keys():
                  exact_counts[build_taxonomy] = 0.0
               else: 
                  exact_counts[build_taxonomy] += 0.0          




         elif level == len(taxonomy) - 1:
            build_taxonomy += ";" + taxonomy[level]

            if build_taxonomy not in exact_counts.keys():
               exact_counts[build_taxonomy] = value
            else: 
               exact_counts[build_taxonomy] += value            


         else:
            build_taxonomy += ";" + taxonomy[level]

            if build_taxonomy not in exact_counts.keys():
               exact_counts[build_taxonomy] = 0.0
            else: 
               exact_counts[build_taxonomy] += 0.0

   else:
      print(taxonomy)

entries = []
for taxonomy, value in exact_counts.items():

   taxonomy = taxonomy.split(";")
   layers = taxonomy[0]

   if len(layers) > 1:

      for level in taxonomy[1:]:
         layers += "\t" + level

   entry = (value, layers)
   entries.append(entry)


# Sort based on the taxonomy
entries.sort(key=lambda x:x[1])


# Write a file with all the entries 
for entry in entries:
   if entry[0] == 0.0:
      counts = ""
   else:
      counts = str(entry[0])
   taxopath = entry[1]
   counts_krona_profile.write(counts + "\t" + taxopath + "\n")



###################################################################
# PART B: Build the .json file for retrieve query ids per domain 
# and export seqs of each domain in a text file
###################################################################

# Track query ids assigned in each domain 
query_names_per_domain = {}

for query, domains in domain_dict.items():

   for domain in domains:

      if domain not in query_names_per_domain.keys():
         query_names_per_domain[domain] = [query]

      else:
         query_names_per_domain[domain].append(query)

query_names_per_domain.pop("taxopath", None)

# Keep some counts! 
total_queries = len(domain_dict.keys()) 

if "Bacteria" in query_names_per_domain:
   total_bacteria  = len(query_names_per_domain["Bacteria"])
else:
   total_bacteria = 0

if "Archaea" in query_names_per_domain:
   total_archaea = len(query_names_per_domain["Archaea"])
else:
   total_archaea = 0

if "Eukaryota" in query_names_per_domain:
   total_eukaryotes = len(query_names_per_domain["Eukaryota"])
else:
   total_eukaryotes = 0

if "DISTANT" in query_names_per_domain:
   total_distant = len(query_names_per_domain["DISTANT"])
else:
   total_distant = 0


# Add metadata of the dict to the dict
query_names_per_domain["metadata"] = { "total queries" : total_queries, \
                                       "Bacteria assignments" : total_bacteria, \
                                       "Archaea assigned" : total_archaea, \
                                       "Eukaryota assigned" : total_eukaryotes, \
                                       "Distant assigned" : total_distant
}

with open('darn_assignments_per_domain.json', 'w') as fp:
    json.dump(query_names_per_domain, fp)



query_fasta_file = open('query.fasta', "r")

queries_dict = {}
ids_mapping = {}

for line in query_fasta_file:

   if line[0] == ">": 

      header = line
      darn_id = line[line.rindex('_')+1:][:-1]
      
   else: 
      queries_dict[header]  = line
      ids_mapping[darn_id] = header


if "Bacteria" in query_names_per_domain:
   bacteria_fasta = open("darn_bacteria_assignments.fasta", "w")
   for query_id in query_names_per_domain["Bacteria"]:

      if query_id in ids_mapping.keys():
         header = ids_mapping[query_id]
         seq = queries_dict[header]
         bacteria_fasta.write(header + seq)

if "Archaea" in query_names_per_domain:
   archaea_fasta = open("darn_archaea_assignments.fasta", "w")
   for query_id in query_names_per_domain["Archaea"]:

      if query_id in ids_mapping.keys():
         header = ids_mapping[query_id]
         seq = queries_dict[header]
         archaea_fasta.write(header + seq)

if "Eukaryota" in query_names_per_domain: 
   eukaryota_fasta = open("darn_eukaryota_assignments.fasta", "w")
   for query_id in query_names_per_domain["Eukaryota"]:

      if query_id in ids_mapping.keys():
         header = ids_mapping[query_id]
         seq = queries_dict[header]
         eukaryota_fasta.write(header + seq)

if "DISTANT" in query_names_per_domain: 
   eukaryota_fasta = open("darn_distant_assignments.fasta", "w")
   for query_id in query_names_per_domain["DISTANT"]:

      if query_id in ids_mapping.keys():
         header = ids_mapping[query_id]
         seq = queries_dict[header]
         eukaryota_fasta.write(header + seq)

print("Parsing script has been completed. \n")
