//creating an in-memory Cypher projection of associated Cuisines based on the ingredients they share in common
CALL gds.graph.create.cypher(
'cuisine_association',
'MATCH (c:Cuisine) RETURN ID(c) AS id',
'MATCH (c1:Cuisine)<--(:Recipe)-->(i:Ingredient)<--(:Recipe)-->(c2:Cuisine)
WHERE c1 <> c2
WITH c1, c2, COUNT(DISTINCT i) AS noOfIngredients
WHERE noOfIngredients >= 100
RETURN ID(c1) AS source, ID(c2) AS target, noOfIngredients AS weight')
 
//running Louvain community detection over the in-memory Cypher projection
CALL gds.louvain.stream(
  'cuisine_association',
  {relationshipWeightProperty:'weight'}
)
YIELD nodeId, communityId, intermediateCommunityIds
WITH communityId, intermediateCommunityIds, COUNT(nodeId) AS cnt, COLLECT(gds.util.asNode(nodeId).name) AS cuisines 
WHERE cnt > 1
RETURN communityId, cnt, cuisines
ORDER BY cnt DESC 
LIMIT 10