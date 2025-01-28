use tarea

show collections

// EJERCICIO 1
db.movies.find()

// EJERCICIO 2
db.movies.find().count()

// EJERCICIO 3 
var nueva_pelicula = {"title": "Anyone but you", "year": 2023, "cast": ["Sydney Sweeney", "Glen Powell"], "genres": ["romance", "comedy"]}
db.movies.insertOne(nueva_pelicula)

db.movies.find().sort({year: -1})

// EJERCICIO 4
var eliminar_pelicula = {"title": "Anyone but you"}
db.movies.deleteOne(eliminar_pelicula)

db.movies.find().sort({year: -1})

// EJERCICIO 5
var query = {"cast": "and"}
db.movies.find(query).count()

// EJERCICIO 6
var query = {}
var operacion = {$pull: {"cast": "and"}}
db.movies.updateMany(query, operacion)

// EJERCICIO 7
var query1 = {"cast": {$eq: []}}
var query2 = {"cast": {$size: 0}}
var logic = {$and: [query1, query2]}
db.movies.find(logic).count

// EJERCICIO 8
var query = {"cast": {$eq: []}}
var operacion = {$push: {"cast": "Undefined"}}
db.movies.updateMany(query, operacion)

var query = {"cast": "Undefined"}
db.movies.find(query)

// EJERCICIO 9 
var query = {"genres": {$eq: []}}
db.movies.find(query).count()

// EJERCICIO 10
var query = {"genres": {$eq: []}}
var operacion = {$push: {"genres": "Undefined"}}
db.movies.updateMany(query, operacion)

var query = {"genres": "Undefined"}
db.movies.find(query)

// EJERCICIO 11
db.movies.find().sort({year: -1}).limit(1).project({_id: 0, year:1})

// EJERCICIO 12
var fase1 = {$match: {"year": {$lte: 2018, $gt: 1998}}}
var fase2 = {$group: {_id: null, total: {$sum: 1}}}
var etapas = [fase1, fase2]
db.movies.aggregate(etapas)

// EJERCICIO 13
var fase1 = {$match: {"year": {$lte: 1969, $gte: 1960}}}
var fase2 = {$group: {_id: null, total: {$sum: 1}}}
var etapas = [fase1, fase2]
db.movies.aggregate(etapas)

// EJERCICIO 14
var fase1 = {$group: {_id: "$year", total: {$sum: 1}}}
var fase2 = {$sort: {total: -1}}
var fase3 = {$limit: 1}
var etapas = [fase1, fase2, fase3]
db.movies.aggregate(etapas)

// EJERCICIO 15
var fase1 = {$group: {_id: "$year", total: {$sum: 1}}}
var fase2 = {$sort: {total: 1}}
var fase3 = {$limit: 3}
var etapas = [fase1, fase2, fase3]
db.movies.aggregate(etapas)

// EJERCICIO 16 
var fase1 = {$unwind: "$cast"}
var fase2 = {$project: {_id: 0}}
var fase3 = {$out: "actors"}
var etapas = [fase1, fase2, fase3]
db.movies.aggregate(etapas)

db.actors.find().count()

// EJERCICIO 17
var fase1 = {$match: {"cast": {$ne: "Undefined"}}}
var fase2 = {$group: {_id: "$cast", cuenta: {$sum: 1}}}
var fase3 = {$sort: {cuenta: -1}}
var fase4 = {$limit: 5}
var etapas = [fase1, fase2, fase3, fase4]
db.actors.aggregate(etapas)

// EJERCICIO 18
var fase1 = {$group: {_id: {title: "$title", year: "$year"}, total_actor: {$sum: 1}}}
var fase2 = {$sort: {total_actor: -1}}
var fase3 = {$limit: 5}
var etapas = [fase1, fase2, fase3]
db.actors.aggregate(etapas)

// EJERCICIO 19
var fase1 = {$match: {"cast": {$ne: "Undefined"}}}
var fase2 = {$group: {_id: "$cast", comienza: {$min: "$year"}, termina: {$max: "$year"}}}
var fase3 = {$project: {_id:1, comienza:1, termina:1, años: {$subtract: ["$termina", "$comienza"]}}}
var fase4 = {$sort: {años: -1}}
var fase5 = {$limit: 5}
var etapas = [fase1, fase2, fase3, fase4, fase5]
db.actors.aggregate(etapas)

// EJERCICIO 20
var fase1 = {$unwind: "$genres"}
var fase2 = {$project: {_id: 0}}
var fase3 = {$out: "genres"}
var etapas = [fase1, fase2, fase3]
db.actors.aggregate(etapas)

db.genres.find().count()

// EJERCICIO 21
var fase1 = {$match: {"genres": {$ne: "Undefined"}}}
var fase2 = {$group: {_id: {year: "$year", genre: "$genre"}, pelis: {$sum: 1}}}
var fase3 = {$sort: {pelis: -1}}
var fase4 = {$limit: 5}
var etapas = [fase1, fase2, fase3, fase4]
db.actors.aggregate(etapas)

// EJERCICIO 22
var fase1 = {$match: {"cast": {$ne: "Undefined"}, "genres": {$ne: "Undefined"}}}
var fase2 = {$unwind: "$genres"}
var fase3 = {$unwind: "$cast"}
var fase4 = {$group: {_id: {actor: "$cast", genre: "$genres"}, numGeneros: {$addToSet: "$genres"}}}
var fase5 = {$group: {_id: "$_id.actor", numGeneros: {$sum: {$size: "$numGeneros"}}, generos: {$addToSet: "$_id.genre"}}}
var fase6 = {$sort: {numGeneros: -1}}
var fase7 = {$limit: 5}
var etapas = [fase1, fase2, fase3, fase4, fase5, fase6, fase7]
db.genres.aggregate(etapas)

// EJERCICIO 23
var fase1 = {$match: {"genres": {$ne: "Undefined"}}}
var fase2 = {$unwind: "$genres"}
var fase3 = {$group: {_id: {title: "$title", year: "$year"}, numGeneros: {$addToSet: "$genres"}, generos: {$addToSet: "$genres"}}}
var fase4 = {$project: {_id: 1, numGeneros: {$size: "$numGeneros"}, generos: 1}}
var fase5 = {$sort: {numGeneros: -1}}
var fase6 = {$limit: 5}
var etapas = [fase1, fase2, fase3, fase4, fase5, fase6]
db.genres.aggregate(etapas)

// EJERCICIO 24
var fase1 = {$unwind: "$cast"}
var fase2 = {$group: {_id: "$title", year: {$first: "$year"}, cast: {$addToSet: "$cast"}}}
var fase3 = {$sort: {year: -1}}
var fase4 = {$limit: 10}
var etapas = [fase1, fase2, fase3, fase4]
db.movies.aggregate(etapas)

// EJERCICIO 25
var fase1 = {$match: {year: 2010}}
var fase2 = {$unwind: "$cast"}
var fase3 = {$group: {_id: {title: "$title", year: "$year"}, totalActors: {$sum: 1}}}
var fase4 = {$sort: {totalActors: -1}}
var fase5 = {$limit: 5}
var etapas = [fase1, fase2, fase3, fase4, fase5]
db.movies.aggregate(etapas)

// EJERCICIO 26
var fase1 = {$match: {year: 2000}}
var fase2 = {$group: {_id: {title: "$title"}, totalGenres: {$sum: 1}}}
var fase3 = {$sort: {totalGenres: -1}}
var fase4 = {$limit: 5}
var etapas = [fase1, fase2, fase3, fase4]
db.genres.aggregate(etapas)