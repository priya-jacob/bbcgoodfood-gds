//quick data profiling
MATCH (c1:Cuisine)<--(:Recipe)-->(i:Ingredient)<--(:Recipe)-->(c2:Cuisine)
WHERE c1 <> c2
WITH c1.name AS cuisine1, c2.name AS cuisine2, i, COUNT(*) AS noOfRecipes
ORDER BY noOfRecipes DESC, i.name 
WITH cuisine1, cuisine2, COUNT(i) AS noOfIngredients, COLLECT(i.name)[..100] AS ingredients
WHERE noOfIngredients >= 100
RETURN DISTINCT apoc.coll.sort([cuisine1,cuisine2]) AS cuisines, noOfIngredients, ingredients
ORDER BY noOfIngredients DESC
