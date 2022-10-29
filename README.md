# Proyecto DCCinema Grupo 1
#### Entrega: 2
#### Url Heroku: https://peli-app.herokuapp.com/


### Logros
- No logramos coverage 100%, particularmente lo que quedo deficiente en testing fue:
 - app/controllers/movie_controller.rb
 - app/controllers/reservas_controller.rb
 
### Consideraciones Generales
- Para poder probar la implementacion de productos hay que ir a https://peli-app.herokuapp.com/products, dentro de esto se puede:
 - Crear nuevos productos
 - Filtrar por categoria con los 3 links
 - Actualizar 
 - Eliminar
- Considerar que en la creacion de productos nuevos existe validacion para que:
 - Que el producto tenga minimo nombre, precio y categoria
 - Si la categoria es Bebestible, se tiene que tener volumen y no se acepta peso
 - Si la categoria es Comestibles, se tiene que tener peso y no se acepta volumen
 - Si la categoria es Souvenir, no se acepta peso ni volumen
 
