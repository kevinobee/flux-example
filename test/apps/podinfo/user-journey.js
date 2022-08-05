import http from 'k6/http';
import { check, group } from 'k6'
import { Trend } from 'k6/metrics'

import { ThinkTime } from '../../utils.js';

let HomePageTrend = new Trend('Podinfo Get homepage', true);

const baseUrl = __ENV.PODINFO_URL
    ? `https://${__ENV.PODINFO_URL}`
    : `http://localhost:9898`;

const endpoints = {
    homepage: `${baseUrl}/`
}

export function checkPodinfoApp() {

    group('Applications: Podinfo user journey', () => {

        let responses;

        responses = http.batch([
            ['GET', endpoints.homepage, null, { tags: { ctype: 'html' } }],
        ], { tag: { name: 'Get Homepage' } });
        check(responses[0], {
            'status was 200': (res) => res.status === 200,
            'text verification': (res) => res.body.includes('greetings from podinfo')
        });

        HomePageTrend.add(responses[0].timings.duration)
        ThinkTime();
    })
}