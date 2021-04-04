//running NodeSimilarity in mutate mode first, notice the SIMILAR relationship and similarity score property being specified
CALL gds.nodeSimilarity.mutate('recipe_bipartite', {
    degreeCutoff: 20,
    similarityCutoff: 0.25,
    topK:100,
    mutateRelationshipType: 'SIMILAR',
    mutateProperty: 'score'
})
YIELD nodesCompared, relationshipsWritten

//running Louvain community detection algorithm over the in-memory graph, notice how we filter the appropriate Node and Relationship (to turn it into a monopartite graph) over which we are to run community detection
CALL gds.louvain.stream('recipe_bipartite', 
{
nodeLabels: ['Recipe'],
relationshipTypes: ['SIMILAR'],
relationshipWeightProperty: 'score', 
maxLevels:10, maxIterations:10, includeIntermediateCommunities:false})
YIELD nodeId, communityId, intermediateCommunityIds
WITH communityId, intermediateCommunityIds, COUNT(nodeId) AS cnt, COLLECT(gds.util.asNode(nodeId).name) AS recipes
WHERE 'dill pickled cucumbers' IN recipes
RETURN communityId, intermediateCommunityIds, cnt, recipes 
ORDER BY cnt DESC LIMIT 100
 
//RETURN COUNT(DISTINCT communityId)
 
//RETURN communityId, intermediateCommunityIds, COUNT(nodeId) AS cnt, COLLECT(gds.util.asNode(nodeId).name) AS recipes 
//ORDER BY cnt DESC LIMIT 100
 
//WITH communityId, COUNT(nodeId) AS size
//RETURN size, COUNT(communityId)
//ORDER BY size DESC
