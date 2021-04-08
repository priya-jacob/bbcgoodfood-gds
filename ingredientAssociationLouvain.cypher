//creating in-memory Cypher projection
CALL gds.graph.create.cypher(
'ingredient_association',    
'MATCH (i:Ingredient) RETURN ID(i) AS id',
'MATCH (n:Recipe)
WITH COUNT(n) AS totalNoOfRecipes
MATCH (i:Ingredient)<-[:INGREDIENT]-(r:Recipe)-[:INGREDIENT]->(j:Ingredient)
WITH i, j, COUNT(r) AS noOfRecipes, totalNoOfRecipes
WHERE noOfRecipes > 1 AND toFloat(noOfRecipes)/toFloat(totalNoOfRecipes) > 0.0075
RETURN ID(i) AS source, ID(j) AS target, noOfRecipes AS weight'
)

//running Louvain community detection over the projected in-memory graph
CALL gds.louvain.stream(
  'ingredient_association',
  {relationshipWeightProperty:'weight'}
)
YIELD nodeId, communityId, intermediateCommunityIds
WITH communityId, intermediateCommunityIds, COUNT(nodeId) AS cnt, COLLECT(gds.util.asNode(nodeId).name) AS recipes 
WHERE cnt > 1
RETURN communityId, cnt, recipes
ORDER BY cnt DESC 
LIMIT 100
