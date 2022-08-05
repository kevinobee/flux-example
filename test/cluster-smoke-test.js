export { checkPodinfoApp } from './apps/podinfo/user-journey.js';
export { checkGrafana } from './infrastructure/monitoring/grafana/user-journey.js';
export { checkPolicyReporter } from './infrastructure/policy/kyverno/user-journey.js';
export { checkLitmusChaos } from './tools/litmuschaos/user-journey.js';

export const options = {

  // httpDebug: 'full',

  thresholds: {
    // the rate of successful checks should be higher than 90%
    checks: ['rate>0.9'],
  },

  scenarios: {
    Podinfo: {
      executor: 'shared-iterations',
      exec: 'checkPodinfoApp',
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
      iterations: 5
    },
    Tools: {
      executor: 'shared-iterations',
      exec: 'checkLitmusChaos',
      vus: 1,
      iterations: 5
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
