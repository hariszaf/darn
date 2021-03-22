#!/usr/bin/python
import sys, json

input_file = open("darn_gappa_assign_per_query.tsv", "r")

dictionary = {}
counter = 0 

for line in input_file:

   line = line.split("\t")
   query_id = line[0]

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

total_bacteria  = len(query_names_per_domain["Bacteria"])
total_archaea = len(query_names_per_domain["Archaea"])
total_eukaryotes = len(query_names_per_domain["Eukaryota"])
total_distant = len(query_names_per_domain["DISTANT"])
total_doubles = len(query_names_per_domain["doubles"])

# add metadata of the dict to the dict
query_names_per_domain["metadata"] = {"total # of queries" : total_queries, \
"total bacteria assigned" : total_bacteria, \
"total archaea assigned" : total_archaea \
}



with open('app.json', 'w') as fp:
    json.dump(query_names_per_domain, fp)


print("Total number of queries: " + str(total_queries))
print("Total number of Bacteria: " + str(total_bacteria))
print("Total number of Archaea: " + str(total_archaea))
print("Total number of Eukaryota: " + str(total_eukaryotes))
print("Total number of distant: " + str(total_distant))
print("Total number of double assigned: " + str(total_doubles))

