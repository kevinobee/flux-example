import http from 'k6/http';
import { check } from 'k6';

import { ThinkTime } from '../../../utils.js';

export function checkGrafana() {
    const res = http.get('http://localhost:3000', { tags: { name: '02_Grafana_Homepage' } });

    check(res, {
        'is status 200': (r) => r.status === 200,
        '02_text verification': (r) =>
            r.body.includes('Grafana'),
    });

    ThinkTime();
}