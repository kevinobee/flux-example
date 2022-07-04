import http from 'k6/http';
import { check, group } from 'k6'
import { Trend } from 'k6/metrics'

import { ThinkTime } from '../../utils.js';

let HomePageTrend = new Trend('LitmusChaos Get homepage', true);

const baseUrl = __ENV.LITMUSCHAOS_URL
  ? `https://${__ENV.LITMUSCHAOS_URL}`
  : `http://localhost:9091`;

const endpoints = {
  homepage: `${baseUrl}/`
}

export function checkLitmusChaos() {

  group('Tools: Litmus Chaos is available', () => {

    let responses;

    responses = http.batch([
      ['GET', endpoints.homepage, null, { tags: { ctype: 'html' } }],
    ], { tag: { name: 'Get Homepage' } });
    check(responses[0], {
      'status was 200': (res) => res.status === 200,
      'text verification': (res) => res.body.includes('ChaosCenter')
    });

    HomePageTrend.add(responses[0].timings.duration)
    ThinkTime();
  })
}
