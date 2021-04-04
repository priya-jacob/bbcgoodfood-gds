//checking stats
CALL gds.louvain.stats(
  'recipe_bipartite',
  {
    nodeLabels: ['Recipe'],
    relationshipTypes: ['SIMILAR'],
    relationshipWeightProperty: 'score', 
    maxLevels:10, maxIterations:10, includeIntermediateCommunities:false}
)
YIELD
  communityCount,
  ranLevels
