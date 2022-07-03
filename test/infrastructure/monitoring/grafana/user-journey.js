import http from 'k6/http';
import { check, group } from 'k6'
import { Trend } from 'k6/metrics'

import { ThinkTime } from '../../../utils.js';

let HomePageTrend = new Trend('Grafana Get homepage', true);

const baseUrl = __ENV.GRAFANA_URL
    ? `https://${__ENV.GRAFANA_URL}`
    : `http://localhost:3000`;

const endpoints = {
    homepage: `${baseUrl}/`
}

export function checkGrafana() {

    group('Observability: Grafana dashboard', () => {

        let responses;

        responses = http.batch([
            ['GET', endpoints.homepage, null, { tags: { ctype: 'html' } }],
        ], { tag: { name: 'Get Homepage' } });
        check(responses[0], {
            'status was 200': (res) => res.status === 200,
            'text verification': (res) => res.body.includes('Grafana')
        });

        HomePageTrend.add(responses[0].timings.duration)
        ThinkTime();
    })
}