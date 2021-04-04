//using Yen’s K shortest path algorithm
MATCH (source:Ingredient {name: 'sichuan peppercorns'}), (target:Ingredient {name: 'kaffir lime leaves'}) 
CALL gds.beta.shortestPath.yens.stream(
  {
    nodeProjection:'*',
    relationshipProjection:{
            INGREDIENT : {
            type: 'INGREDIENT',
            orientation: 'UNDIRECTED'
            },
            CUISINE : {
            type: 'CUISINE',
            orientation: 'UNDIRECTED'
            },
            FUZZY_MATCH : {
            type: 'FUZZY_MATCH',
            orientation: 'UNDIRECTED'
            }  
        },
    sourceNode: id(source),
    targetNode: id(target),
    k: 3,
    path: true
  }
)
YIELD index, sourceNode, targetNode, totalCost, nodeIds, costs, path
RETURN
    //index,
    //gds.util.asNode(sourceNode).name AS sourceNodeName,
    //gds.util.asNode(targetNode).name AS targetNodeName,
    //totalCost,
    [nodeId IN nodeIds | gds.util.asNode(nodeId).name] AS nodeNames,
    //costs,
    path
//ORDER BY index
