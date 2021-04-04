CALL apoc.periodic.iterate
("MATCH (i:Ingredient) RETURN i", 
"MATCH (j:Ingredient) 
WHERE i<>j
WITH i, j,
apoc.text.sorensenDiceSimilarity(apoc.text.clean(i.name), apoc.text.clean(j.name)) AS sorensen,
apoc.text.jaroWinklerDistance(apoc.text.clean(i.name), apoc.text.clean(j.name)) AS jaro, 
apoc.text.levenshteinSimilarity(apoc.text.clean(i.name), apoc.text.clean(j.name)) AS levenshtein, 
apoc.coll.avg([apoc.text.sorensenDiceSimilarity(apoc.text.clean(i.name), apoc.text.clean(j.name)),
apoc.text.jaroWinklerDistance(apoc.text.clean(i.name), apoc.text.clean(j.name)), 
apoc.text.levenshteinSimilarity(apoc.text.clean(i.name), apoc.text.clean(j.name))]) AS avg
WHERE avg >= 0.75
MERGE (i)-[r:FUZZY_MATCH]-(j) SET r.score = avg", 
{batchSize: 10, parallel: false})
