//using classic Jaccard Similarity from GDS and comparing results
MATCH (r1:Recipe {id:'5312021'})
WITH r1, 
 
[(r1)-[:INGREDIENT]->(i1:Ingredient)|ID(i1)]+
[(r1)-[:INGREDIENT]->(:Ingredient)-[:FUZZY_MATCH]-(i1:Ingredient)|ID(i1)]+
[(r1)-[:INGREDIENT]->(i1:Ingredient)|ID(i1)]+
[(r1)-[:INGREDIENT]->(:Ingredient)-[:FUZZY_MATCH]-(i1:Ingredient)|ID(i1)]+
[(r1)-[:INGREDIENT]->(i1:Ingredient)|ID(i1)]+
[(r1)-[:INGREDIENT]->(:Ingredient)-[:FUZZY_MATCH]-(i1:Ingredient)|ID(i1)]+
[(r1)-[:INGREDIENT]->(i1:Ingredient)|ID(i1)]+
[(r1)-[:INGREDIENT]->(:Ingredient)-[:FUZZY_MATCH]-(i1:Ingredient)|ID(i1)]+
 
[(r1)-[:KEYWORD]->(k1:Keyword)|ID(k1)]+
[(r1)-[:KEYWORD]->(k1:Keyword)|ID(k1)]+
[(r1)-[:KEYWORD]->(k1:Keyword)|ID(k1)]+
 
[(r1)-[:CUISINE]->(c1:Cuisine)|ID(c1)]+
[(r1)-[:CUISINE]->(c1:Cuisine)|ID(c1)]+
 
[(r1)-[:COLLECTION]->(n1:Collection)|ID(n1)]+
[(r1)-[:COLLECTION]->(n1:Collection)|ID(n1)]+
 
[(r1)-[:DIET_TYPE]->(d1:DietType)|ID(d1)]+
[(r1)-[:COURSE]->(o1:Course)|ID(o1)]+
[(r1)-[:SKILL_LEVEL]->(l1:SkillLevel)|ID(l1)]
AS list1
MATCH (r2:Recipe)
WHERE r1 <> r2
WITH r1, list1, r2, 
[(r2)-[:INGREDIENT]->(i2:Ingredient)|ID(i2)]+
[(r2)-[:INGREDIENT]->(:Ingredient)-[:FUZZY_MATCH]-(i2:Ingredient)|ID(i2)]+
[(r2)-[:INGREDIENT]->(i2:Ingredient)|ID(i2)]+
[(r2)-[:INGREDIENT]->(:Ingredient)-[:FUZZY_MATCH]-(i2:Ingredient)|ID(i2)]+
[(r2)-[:INGREDIENT]->(i2:Ingredient)|ID(i2)]+
[(r2)-[:INGREDIENT]->(:Ingredient)-[:FUZZY_MATCH]-(i2:Ingredient)|ID(i2)]+
[(r2)-[:INGREDIENT]->(i2:Ingredient)|ID(i2)]+
[(r2)-[:INGREDIENT]->(:Ingredient)-[:FUZZY_MATCH]-(i2:Ingredient)|ID(i2)]+
 
[(r2)-[:KEYWORD]->(k2:Keyword)|ID(k2)]+
[(r2)-[:KEYWORD]->(k2:Keyword)|ID(k2)]+
[(r2)-[:KEYWORD]->(k2:Keyword)|ID(k2)]+
 
[(r2)-[:CUISINE]->(c2:Cuisine)|ID(c2)]+
[(r2)-[:CUISINE]->(c2:Cuisine)|ID(c2)]+
 
[(r2)-[:COLLECTION]->(n2:Collection)|ID(n2)]+
[(r2)-[:COLLECTION]->(n2:Collection)|ID(n2)]+
 
[(r2)-[:DIET_TYPE]->(d2:DietType)|ID(d2)]+
[(r2)-[:COURSE]->(o2:Course)|ID(o2)]+
[(r2)-[:SKILL_LEVEL]->(l2:SkillLevel)|ID(l2)]
AS list2
WHERE apoc.node.degree.out(r2) >= 20  //degreeCutOff
WITH r1.id AS recipeId1, r1.name AS recipe1, r2.name AS recipe2, gds.alpha.similarity.jaccard(list1, list2) AS similarity
WHERE similarity >= 0.25 //similarityCutOff
WITH recipeId1, recipe1, recipe2, similarity
ORDER BY similarity DESC
LIMIT 100 //topK
RETURN recipeId1, recipe1, COLLECT(recipe2) AS similarRecipes, COUNT(recipe2) AS noOfSimilarRecipes