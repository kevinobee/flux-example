import { sleep } from 'k6';

const THINK_TIME = 1;

export function ThinkTime(multiplier = 1.0) {
    sleep(THINK_TIME * multiplier);
}
