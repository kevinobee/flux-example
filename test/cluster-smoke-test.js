export { checkEmojiVotoApp } from './apps/emojivoto/user-journey.js';
export { checkGrafana } from './infrastructure/monitoring/grafana/user-journey.js';
export { checkLitmusChaos } from './tools/litmuschaos/user-journey.js';

export const options = {

  thresholds: {
    http_req_failed: ['rate<=0.05'],
    http_req_duration: ['p(99)<500'], // 99% of requests must complete below 500ms
  },

  scenarios: {
    EmojiVoto: {
      executor: 'shared-iterations',
      exec: 'checkEmojiVotoApp',
      vus: 10,
      iterations: 20
    },
    Observability: {
      executor: 'shared-iterations',
      exec: 'checkGrafana',
      vus: 2,
      iterations: 5
    },
    Tools: {
      executor: 'shared-iterations',
      exec: 'checkLitmusChaos',
      vus: 1,
      iterations: 2
    }
  },

  ext: {
    loadimpact: {
      projectID: 3589514,
      // Test runs with the same name groups test runs together
      name: "Flux Example: Cluster Services"
    }
  }
};
