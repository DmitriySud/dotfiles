#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import bson.json_util
import uuid


def make_ammo(method, url, headers, case, body):
    """ makes phantom ammo """
    # http request w/o entity body template
    req_template = '%s %s HTTP/1.1\r\n' '%s\r\n' '\r\n'

    # http request with entity body template
    req_template_w_entity_body = (
        '%s %s HTTP/1.1\r\n' '%s\r\n' 'Content-Length: %d\r\n' '\r\n' '%s\r\n'
    )

    if not body:
        req = req_template % (method, url, headers)
    else:
        req = req_template_w_entity_body % (
            method,
            url,
            headers,
            len(body),
            body,
        )

    # phantom ammo template
    ammo_template = '%d %s\n' '%s'

    return ammo_template % (len(req), case, req)


def main():
    for i in range(100000):
        body = bson.json_util.dumps(
            {
                'queue_name': 'test_queue',
                'eta': '1970-01-01T00:00:00.000Z',
                'task_id': uuid.uuid4().hex,
                'args': ('1',),
                'kwargs': {},
            },
        )

        headers = (
            'Host: taxi-userver-load-tank-2.vla.yp-c.yandex.net\r\n'
            + 'User-Agent: tank\r\n'
            + 'Accept: */*\r\n'
            + 'Connection: keep-alive\r\n'
            + 'Content-Type: application/json\r\n'
        )

        sys.stdout.write(make_ammo('GET', '/hello', headers, 'good', None))


if __name__ == '__main__':
    main()
