# Документация к API
## POST /register
Принимает JSON:
```
{
	phone: str # состоит ровно из 11 цифр
	name: str
	lastname: str
	password: str # содержит минимум 8 символов
}
```
В случае, если номер телефона занят, клиент получит ошибку 409.
## POST /login
Принимает JSON:
```
{
	phone: str
	password: str
}
```
При успешной идентификации клиент получит access и refresh токены.  
В случае неверного номера телефона или пароля клиент получит ошибку 401.
## POST /refresh
Принимает JSON:
```
{
	refresh_token: str
}
```
Если токен истёк или невалиден (нет в базе активных сессий), то клиент получит ошибку 401.  
Иначе будет получен новый access токен.
## POST /logout
Принимает JSON:
```
{
	refresh_token: str
}
```
Если токен истёк, то клиент получит ошибку 401.
## GET /me
Тестовая функция, **принимает в заголовке http запроса access токен**:
```
Authorization: Bearer eyJhbGci...
```
Если токен валидный, то клиент получит сообщение с номером телефона пользователя.
## GET /products?limit=5&offset=0
**Принимает в заголовке http запроса access токен.**  
limit — сколько товаров будет отправлено,  
offset — с какого товара будет начинаться выборка  
В случае успеха будет получен JSON формата:
```
{
  "products": [
    {
      "id": i+1,
      "name": "Ноутбук ASUS VivoBook",
      "price": 74990,
      "image": "http://0.0.0.0:8000/static/images/tmp.jpg",
      "description": "Лёгкий и быстрый ноутбук для повседневной работы",
      "isInCart": 1,
      "isFavourite": 0
    },
    ...
  ],
  "total_count": n,
  "limit": k,
  "offset": i
}
```
## GET /products/public?limit=5&offset=0
Выполняет ту же функцию, что и `/products`, но не принимает access токен.  
Соответственно isInCart и isFavourite всегда false.
## POST /cart/add?product_id=i
**Принимает в заголовке http запроса access токен.**  
## DELETE /cart/remove?product_id=i
**Принимает в заголовке http запроса access токен.**  
## POST /favourite/add?product_id=i
**Принимает в заголовке http запроса access токен.**  
## DELETE /favourite/remove?product_id=i
**Принимает в заголовке http запроса access токен.**  
## GET /cart
**Принимает в заголовке http запроса access токен.**  
Возвращается массив корзины в формате JSON
## GET /favourite
**Принимает в заголовке http запроса access токен.**  
Возвращается массив любимых товаров в формате JSON