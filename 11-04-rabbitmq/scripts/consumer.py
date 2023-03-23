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


def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)


channel.basic_consume(queue='nedorezov', on_message_callback=callback, auto_ack=True)
channel.start_consuming()