#!/usr/bin/env python
# coding=utf-8
import pika

conn_params = {'cluster': {'host': '192.168.0.231', 'auth': {'username': 'admin', 'password': '123456'}}}
credentials = pika.PlainCredentials(**conn_params['cluster']['auth'])
parameters = pika.ConnectionParameters(
    host=conn_params['cluster']['host'],
    credentials=credentials,
)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.queue_declare(queue='nedorezov')
channel.basic_publish(exchange='', routing_key='nedorezov', body='Hello Netology from Smutosey!')
connection.close()