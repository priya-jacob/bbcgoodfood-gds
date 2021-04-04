//using PageRank over in-memory native projection
CALL gds.pageRank.stream('recipe_bipartite',
{
nodeLabels: ['Recipe'],
relationshipTypes: ['SIMILAR'],
relationshipWeightProperty: 'score'}) 
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS recipe, score
ORDER BY score DESC LIMIT 10