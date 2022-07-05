import http from 'k6/http';
import { check, group } from 'k6'
import { Trend } from 'k6/metrics'

import { ThinkTime } from '../../../utils.js';

let HomePageTrend = new Trend('Policy Reporter Get homepage', true);

const baseUrl = __ENV.POLICY_REPORTER_URL
    ? `https://${__ENV.POLICY_REPORTER_URL}`
    : `http://localhost:8082`;

const endpoints = {
    homepage: `${baseUrl}/`
}

export function checkPolicyReporter() {

    group('Observability: Policy Reporter is available', () => {

        let responses;

        responses = http.batch([
            ['GET', endpoints.homepage, null, { tags: { ctype: 'html' } }],
        ], { tag: { name: 'Get Homepage' } });
        check(responses[0], {
            'status was 200': (res) => res.status === 200,
            'text verification': (res) => res.body.includes('Policy Reporter')
        });

        HomePageTrend.add(responses[0].timings.duration)
        ThinkTime();
    })
}