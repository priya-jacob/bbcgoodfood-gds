//schema creation

CREATE CONSTRAINT ON (n:Recipe) ASSERT n.id IS UNIQUE;
CREATE CONSTRAINT ON (n:Ingredient) ASSERT n.name IS UNIQUE;
CREATE CONSTRAINT ON (n:Keyword) ASSERT n.name IS UNIQUE;
CREATE CONSTRAINT ON (n:DietType) ASSERT n.name IS UNIQUE;
CREATE CONSTRAINT ON (n:Author) ASSERT n.name IS UNIQUE;
CREATE CONSTRAINT ON (n:Collection) ASSERT n.name IS UNIQUE;
CREATE CONSTRAINT ON (n:Course) ASSERT n.name IS UNIQUE;
CREATE CONSTRAINT ON (n:SkillLevel) ASSERT n.name IS UNIQUE;
CREATE CONSTRAINT ON (n:Cuisine) ASSERT n.name IS UNIQUE;

//data loading

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
       toLower(value.page.title) AS title,
       toLower(value.page.article.description) AS description,
       value.page.recipe.cooking_time AS cookingTime,
       value.page.recipe.prep_time AS preparationTime,
       value.page.recipe.serves AS serves,
       value.page.recipe.ratings AS ratings
MERGE (r:Recipe {id: id})
SET r.cookingTime = cookingTime,
    r.preparationTime = preparationTime,
    r.name = title,
    r.description = description,
    r.serves = serves,
    r.ratings = ratings;

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
       toLower(value.page.article.author) AS author
MERGE (a:Author {name: author})
WITH a,id
MATCH (r:Recipe {id:id})
MERGE (a)-[:CREATED]->(r);

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
     value.page.recipe.ingredients AS ingredients
MATCH (r:Recipe {id:id})
FOREACH (ingredient IN ingredients |
  MERGE (i:Ingredient {name: toLower(ingredient)})
  MERGE (r)-[:INGREDIENT]->(i)
);

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
       value.page.recipe.keywords AS keywords
MATCH (r:Recipe {id:id})
FOREACH (keyword IN keywords |
  MERGE (k:Keyword {name: toLower(keyword)})
  MERGE (r)-[:KEYWORD]->(k)
);

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
       value.page.recipe.diet_types AS dietTypes
MATCH (r:Recipe {id:id})
FOREACH (dietType IN dietTypes |
  MERGE (d:DietType {name: toLower(dietType)})
  MERGE (r)-[:DIET_TYPE]->(d)
);

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
       value.page.recipe.collections AS collections
MATCH (r:Recipe {id:id})
FOREACH (collection IN collections |
  MERGE (c:Collection {name: toLower(collection)})
  MERGE (r)-[:COLLECTION]->(c)
);

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
       toLower(value.page.recipe.skill_level) AS skillLevel
MERGE (s:SkillLevel {name: skillLevel})
WITH s,id
MATCH (r:Recipe {id:id})
MERGE (r)-[:SKILL_LEVEL]->(s);

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
       toLower(value.page.recipe.cusine) AS cuisine
MERGE (c:Cuisine {name: cuisine})
WITH c,id
MATCH (r:Recipe {id:id})
MERGE (r)-[:CUISINE]->(c);

CALL apoc.load.json($jsonFile) YIELD value
WITH value.page.article.id AS id,
       value.page.recipe.courses AS courses
MATCH (r:Recipe {id:id})
FOREACH (course IN courses |
  MERGE (c:Course {name: toLower(course)})
  MERGE (r)-[:COURSE]->(c)
);

//data profiling

CALL db.labels() YIELD label
CALL apoc.cypher.run('MATCH (n:`'+ label +'`) RETURN COUNT(n) AS cnt',{}) YIELD value
RETURN label, value.cnt

CALL db.relationshipTypes() YIELD relationshipType
CALL apoc.cypher.run('MATCH ()-[r:`'+ relationshipType +'`]->() RETURN COUNT(r) AS cnt',{}) YIELD value
RETURN relationshipType, value.cnt

//clean up

MATCH ()-[r:CUISINE]-(c:Cuisine)
WHERE c.name = ''
DELETE r
RETURN COUNT(r)

MATCH ()<-[r:CREATED]-(n:Author)
WHERE n.name = ''
DELETE r
RETURN COUNT(r)

MATCH (n:Author)
WHERE n.name = ''
DELETE n

MATCH (n:Cuisine)
WHERE n.name = ''
DELETE n

MATCH (r:Recipe)
WHERE r.name CONTAINS '&amp;'
SET r.name = replace(r.name,'&amp;','')
RETURN COUNT(r)

MATCH (r:Recipe)
WHERE r.name CONTAINS '&#039;'
SET r.name = replace(r.name,'&#039;','')
RETURN COUNT(r)