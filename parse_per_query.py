#!/usr/bin/python

# developed by: Haris Zafeiropoulos
# in the framework of the DARN project

import sys, json

input_file = open("darn_gappa_assign_per_query.tsv", "r")

domain_dict = {}
counter = 0 
lwr_dict = {}


for line in input_file:

   line = line.split("\t")
   query_id = line[0]

   # Check if it is actuall a query sequence; otherwise move to the next
   if "Query" not in query_id:
      continue

   else:

      taxonomy = line[-1]
      domain = taxonomy.split(";")[0]
      taxonomy = taxonomy[:-1]

      if "\n" in domain:
         domain = domain[:-1]

      if query_id not in domain_dict.keys():
         domain_dict[query_id] = [domain]

      else:
         domain_dict[query_id].append(domain)

      lwr = line[1]

      if taxonomy not in lwr_dict.keys():
         lwr_dict[taxonomy] = float(lwr)
      
      else:
         lwr_dict[taxonomy] += float(lwr)

# build krona input 
output_file = open("darn_pres_abs.profile", "w")
entries = []
for taxonomy, value in lwr_dict.items():

   taxonomy = taxonomy.split(";")

   layers = taxonomy[0]

   if len(layers) > 1:

      for level in taxonomy[1:]:
         layers += "\t" + level

   entry = (value, layers)
   entries.append(entry)


# sort based on the taxonomy
entries.sort(key=lambda x:x[1])

for entry in entries:

   print(str(entry[0]) + "\t" + entry[1])
   output_file.write(str(entry[0]) + "\t" + entry[1] + "\n")



query_names_with_doubles = []
for key, value in domain_dict.items():

   if len(value) > 2: 

      domain_dict[key] = set(value)
      query_names_with_doubles.append(key)


query_names_per_domain = {}

if len(query_names_with_doubles) > 0 :
   query_names_per_domain["doubles"] = query_names_with_doubles

for query, domains in domain_dict.items():

   for domain in domains:

      if domain not in query_names_per_domain.keys():
         query_names_per_domain[domain] = [query]

      else:
         query_names_per_domain[domain].append(query)

      
query_names_per_domain.pop("taxopath", None)





total_queries = len(domain_dict.keys()) - 1

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


# add metadata of the dict to the dict
query_names_per_domain["metadata"] = {"total queries" : total_queries, \
"Bacteria assignments" : total_bacteria, \
"Archaea assigned" : total_archaea, \
"Eukaryota assigned" : total_eukaryotes, \
"Distant assigned" : total_distant
}



with open('darn_assignments_per_domain.json', 'w') as fp:
    json.dump(query_names_per_domain, fp)



