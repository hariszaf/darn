#!/usr/bin/python
import sys, json

input_file = open("darn_gappa_assign_per_query.tsv", "r")

dictionary = {}
counter = 0 

for line in input_file:

   line = line.split("\t")
   query_id = line[0]

   if "Query" not in query_id:
      continue
   else:

      taxonomy = line[-1].split(";")
      domain = taxonomy[0]

      if "\n" in domain:
         domain = domain[:-1]

      if query_id not in dictionary.keys():
         dictionary[query_id] = [domain]

      else:
         dictionary[query_id].append(domain)


query_names_with_doubles = []
for key, value in dictionary.items():

   if len(value) > 2: 

      dictionary[key] = set(value)
      query_names_with_doubles.append(key)


query_names_per_domain = {}
query_names_per_domain["doubles"] = query_names_with_doubles

for query, domains in dictionary.items():

   for domain in domains:

      if domain not in query_names_per_domain.keys():
         query_names_per_domain[domain] = [query]

      else:
         query_names_per_domain[domain].append(query)

      
query_names_per_domain.pop("taxopath", None)





total_queries = len(dictionary.keys()) - 1

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



