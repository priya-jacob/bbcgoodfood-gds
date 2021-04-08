//persisting monopartite graph
MATCH (n:Recipe)
WITH COUNT(n) AS totalNoOfRecipes
MATCH (i:Ingredient)<-[:INGREDIENT]-(r:Recipe)-[:INGREDIENT]->(j:Ingredient)
WHERE i <> j
WITH i, j, COUNT(DISTINCT r) AS noOfRecipes, totalNoOfRecipes
WHERE noOfRecipes>1 AND toFloat(noOfRecipes)/toFloat(totalNoOfRecipes) > 0.0075
WITH i, j, noOfRecipes
MERGE (i)-[r:INGREDIENT_ASSOCIATED_WITH]-(j)
RETURN COUNT(r)

//running Link Prediction algorithms
MATCH (n1:Ingredient{name:'butter'})
MATCH (n2:Ingredient{name:'sugar'})
RETURN 
 gds.alpha.linkprediction.commonNeighbors(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS cn_score,
 gds.alpha.linkprediction.preferentialAttachment(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS pa_score,
 gds.alpha.linkprediction.adamicAdar(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS aa_score,
 gds.alpha.linkprediction.resourceAllocation(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS ra_score,
 gds.alpha.linkprediction.totalNeighbors(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS tn_score
 
MATCH (n1:Ingredient{name:'chilli'})
MATCH (n2:Ingredient{name:'ice cream'})
WHERE NOT EXISTS((n1)<--(:Recipe)-->(n2))
RETURN 
 gds.alpha.linkprediction.commonNeighbors(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS cn_score,
 gds.alpha.linkprediction.preferentialAttachment(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS pa_score,
 gds.alpha.linkprediction.adamicAdar(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS aa_score,
 gds.alpha.linkprediction.resourceAllocation(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS ra_score,
 gds.alpha.linkprediction.totalNeighbors(n1, n2, {relationshipQuery:'INGREDIENT_ASSOCIATED_WITH'}) AS tn_score
