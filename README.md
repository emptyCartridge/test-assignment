установить зависимости: 
pip install pandas 
pip install sqlalchemy 
Скачать дамп файл БД https://drive.google.com/file/d/1XeAEMdH_qiZBvjs073zrQewpx-3YvCtk/view?usp=sharing 
Создать папку init в ta_db/. Положить скачанный init.sql в ta_db/init/ 
Выполнить docker-compose -f .\ta_db\docker-compose.yml up -d БД наполнится из дампа init.sql (это займет около минуты) 
Запустить main_sample.py, в результате соберется файл .csv с данными для анализа распределения.
