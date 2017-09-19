# Тестовое задание для Тьнькофф

## Цель
Получить фан, ну и написать параллельно тестовое задание.

## Задача
Нужно создать приложение "Тинькофф Новости", которое будет загружать из API https://api.tinkoff.ru/v1/news заголовки новостей банка и показывать их в виде списка. 
В каждом элементе списка i должен отображаться текст из поля payload[i].text. Список должен быть отсортирован по полю publicationDate по убыванию. Полученные данные должны кешироваться на клиенте. Данные должны обновляться после оттягивания (pull-to-refresh). 
При нажатии на каждую новость, она должна открывать новый экран и показывать содержимое (payload.content) загруженное из API https://api.tinkoff.ru/v1/news_content?id={ payload[i].id}. Уделять много внимания дизайну не стоит, но чистый аккуратный интерфейс обязателен. 
Приложение должно быть написано на Swift. При реализации нельзя пользоваться любыми привычными инструментами/библиотеками. В качестве кеша использовать CoreData. 

## Несколько слов о реализации
Ну это какбы VIPER без буквы P. Модели прям на прямую на view передаю ибо БЛ модели, не сильно отличаются от ViewModel и смысла ради тестового задания упахиваться и делать полный стек я не видел.
Да и протоколов шибком нету - лишний геморой.
А вот разбиение по ответственностям достаточно хорошее.
С CoreData работал почти по учебнику - первый раз на практике его использовал. В принципе на swift оказалось не сильно сложно.
Так как по требованиям ничего нельзя использовать, то Router является и Dependency injector-ом. Надо же было хоть както отвязаться.
Очень много мыслей в виде комментариев в коде.

Писал не думая - на автомате. Максиум, что на названия классов тратил по пару минут, дабы они были хоть слегка адекватными.

## Время
Всего потратил 7 часов, в это время входит:
* Изучение того что возвращает API
* Изучение CoreData
* Написание кода
* Написание прикольных комментариев


