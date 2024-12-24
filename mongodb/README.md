# mongodb дз

* установить MongoDB одним из способов: ВМ, докер;
* заполнить данными;
* написать несколько запросов на выборку и обновление данных

**Запускаем mongodb :**

```bash
cd "путь к папке с docker-compose.yml"
docker compose up -d 
```

ждем пока запустится и выполняем команды чтобы заполнить базу:

```bash
docker cp .\books.json mongodb-mongo-1:\books.json 
docker exec -it mongodb-mongo-1 bash
mongoimport --authenticationDatabase=admin --drop -c books --uri mongodb://root:example@mongo:27017/collection books.json 
```

запускаем консоль монго и выполняем команды:

```bash
mongosh mongodb://root:example@mongo:27017

test> use collection
switched to db collection
# количество книг всего
collection> db.books.countDocuments()
431
# количество опубликованных книг
collection> db.books.countDocuments({status:'PUBLISH'})
363
# посчитаем количество книг по категориям
collection> db.books.aggregate([{$group:{_id:'$status',count:{$sum:1}}}])
[ { _id: 'MEAP', count: 68 }, { _id: 'PUBLISH', count: 363 } ]
# посчитаем количество страниц у книг по категориям
collection> db.books.aggregate([{$group:{_id:'$status',count:{$sum:'$pageCount'}}}])
[ { _id: 'MEAP', count: 1775 }, { _id: 'PUBLISH', count: 122896 } ]
# посчитаем количество книг которые изданы после 02-02-2009
collection> db.books.countDocuments({publishedDate:{$gt : ISODate('2009-02-02T08:00:00.000Z')}})
161
# Вывести все книги, где автор содержит "Ahmed"
collection> db.books.find({authors:/.*Ahmed.*/},{title:1,authors:1})
[
  {
    _id: 5,
    title: 'Flex 4 in Action',
    authors: [ 'Tariq Ahmed', 'Dan Orlando', 'John C. Bland II', 'Joel Hooks' ]
  },
  {
    _id: 4,
    title: 'Flex 3 in Action',
    authors: [ 'Tariq Ahmed with Jon Hirschi', 'Faisal Abid' ]
  },
  {
    _id: 298,
    title: 'Becoming Agile',
    authors: [ 'Greg Smith', 'Ahmed Sidky' ]
  }
]
```

пробуем получить статы выполнения

``` bash
collection> db.books.find({authors:/.*Ahmed.*/},{title:1,authors:1}).explain("executionStats")
{
  explainVersion: '1',
  queryPlanner: {
    namespace: 'collection.books',
    parsedQuery: { authors: { '$regex': '.*Ahmed.*' } },
    indexFilterSet: false,
    planCacheShapeHash: 'ECB76EA6',
    planCacheKey: 'D6FE6956',
    optimizationTimeMillis: 0,
    maxIndexedOrSolutionsReached: false,
    maxIndexedAndSolutionsReached: false,
    maxScansToExplodeReached: false,
    prunedSimilarIndexes: false,
    winningPlan: {
      isCached: false,
      stage: 'PROJECTION_SIMPLE',
      transformBy: { title: 1, authors: 1 },
      inputStage: {
        stage: 'COLLSCAN',
        filter: { authors: { '$regex': '.*Ahmed.*' } },
        direction: 'forward'
      }
    },
    rejectedPlans: []
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 3,
    executionTimeMillis: 0,
    totalKeysExamined: 0,
    totalDocsExamined: 431,
    executionStages: {
      isCached: false,
      stage: 'PROJECTION_SIMPLE',
      nReturned: 3,
      executionTimeMillisEstimate: 0,
      works: 432,
      advanced: 3,
      needTime: 428,
      needYield: 0,
      saveState: 0,
      restoreState: 0,
      isEOF: 1,
      transformBy: { title: 1, authors: 1 },
      inputStage: {
        stage: 'COLLSCAN',
        filter: { authors: { '$regex': '.*Ahmed.*' } },
        nReturned: 3,
        executionTimeMillisEstimate: 0,
        works: 432,
        advanced: 3,
        needTime: 428,
        needYield: 0,
        saveState: 0,
        restoreState: 0,
        isEOF: 1,
        direction: 'forward',
        docsExamined: 431
      }
    }
  },
  queryShapeHash: '94B4BB0306F5A5FE35D6BCAB6F38D1318FE057629A5C14947EF308F6F7BF3DCF',
  command: {
    find: 'books',
    filter: { authors: /.*Ahmed.*/ },
    projection: { title: 1, authors: 1 },
    '$db': 'collection'
  },
  serverInfo: {
    host: 'ddabadab7d44',
    port: 27017,
    version: '8.0.4',
    gitVersion: 'bc35ab4305d9920d9d0491c1c9ef9b72383d31f9'
  },
  serverParameters: {
    internalQueryFacetBufferSizeBytes: 104857600,
    internalQueryFacetMaxOutputDocSizeBytes: 104857600,
    internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
    internalDocumentSourceGroupMaxMemoryBytes: 104857600,
    internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
    internalQueryProhibitBlockingMergeOnMongoS: 0,
    internalQueryMaxAddToSetBytes: 104857600,
    internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
    internalQueryFrameworkControl: 'trySbeRestricted',
    internalQueryPlannerIgnoreIndexWithCollationForRegex: 1
  },
  ok: 1
}
```
executionTimeMillis: 0,
stage: 'COLLSCAN'

попробуем сделать индекс

``` bash

db.users.createIndex({'authors' : 1})

#  прошлый запрос все так же планируется, попробуем по значению поля

db.books.find({authors: 'Greg Smith'},{title:1,authors:1}).explain("executionStats")

```
По итогу индекс не используется .. видимо бд слишком мелкая, проще коллсканом пробежать.
