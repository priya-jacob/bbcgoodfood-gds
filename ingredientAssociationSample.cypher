//quick data profiling
MATCH (n:Recipe)
WITH COUNT(n) AS totalNoOfRecipes
MATCH (i:Ingredient)<-[:INGREDIENT]-(r:Recipe)-[:INGREDIENT]->(j:Ingredient)
WITH i.name AS ingredient1, j.name AS ingredient2, COUNT(r) AS noOfRecipes, totalNoOfRecipes, apoc.coll.sort(apoc.coll.toSet(COLLECT(r.name)))[..10] AS sampleRecipes
WHERE noOfRecipes>1 AND toFloat(noOfRecipes)/toFloat(totalNoOfRecipes) > 0.0075
RETURN DISTINCT apoc.coll.sort([ingredient1,ingredient2]) AS ingredients, noOfRecipes, sampleRecipes
ORDER BY noOfRecipes DESC
LIMIT 50
