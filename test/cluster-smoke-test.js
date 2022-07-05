export { checkEmojiVotoApp } from './apps/emojivoto/user-journey.js';
export { checkGrafana } from './infrastructure/monitoring/grafana/user-journey.js';
export { checkPolicyReporter } from './infrastructure/policy/kyverno/user-journey.js';
export { checkLitmusChaos } from './tools/litmuschaos/user-journey.js';

export const options = {

  // httpDebug: 'full',

  scenarios: {
    EmojiVoto: {
      executor: 'shared-iterations',
      exec: 'checkEmojiVotoApp',
      vus: 10,
      iterations: 30
    },
    Observability: {
      executor: 'shared-iterations',
      exec: 'checkGrafana',
      vus: 2,
      iterations: 5
    },
    Policy: {
      executor: 'shared-iterations',
      exec: 'checkPolicyReporter',
      vus: 1,
      iterations: 1
    },
    Tools: {
      executor: 'shared-iterations',
      exec: 'checkLitmusChaos',
      vus: 1,
      iterations: 1
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
