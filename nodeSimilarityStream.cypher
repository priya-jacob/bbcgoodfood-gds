//create a native projection bipartite graph
CALL gds.graph.create
('recipe_bipartite',
['Recipe','Ingredient','Keyword','Cuisine','Collection','DietType','Course','SkillLevel'],
'*'
)

//using NodeSimilarity GDS algorithm in stream mode for one recipe in question
CALL gds.nodeSimilarity.stream('recipe_bipartite',{
  degreeCutoff: 20,
  similarityCutoff: 0.25,
  topK:100})
YIELD node1, node2, similarity
WHERE node1 <> node2 AND gds.util.asNode(node1).id = '5312021'
WITH gds.util.asNode(node1).id as recipeId1, gds.util.asNode(node1).name as recipe1, gds.util.asNode(node2).name as recipe2, gds.util.asNode(node2).id as recipeId2, similarity
ORDER BY similarity DESC
RETURN recipeId1, recipe1, COLLECT(recipe2) AS similarRecipes, COUNT(recipe2) AS noOfSimilarRecipes
//ORDER BY size(similarRecipes) DESC
//LIMIT 100
