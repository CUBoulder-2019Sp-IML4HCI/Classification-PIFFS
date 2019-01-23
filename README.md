# Classification-PIFFS
The Pilot Fatigue Finding System (PIFFS) aims to prevent sleepiness, fatigue, and degenerating vigilance of airline pilots using a wake up alarm.

## Functional Goal
The goal of the Pilot Fatigue Finding System (PIFFS) is to prevent sleepiness, fatigue and degenerating vigilance of airline transport pilots. During prolonged cruise flights, pilots are prone to falling asleep. PIFFS aims to detect three states of fatigue using facial recognition technology. Once a severe state of fatigue, or even worse, sleep, is detected, the system responds with an alarming sound and a text message, prompting the pilot to regain attention and situational awareness.

## Why Classification is useful
In this first model of the PIFFS system, three different states will be detected:
- Wakefulness
- Drowsiness
- Sleeping

All three states can be marked out by facial parameters. Either of the three states is always present for the pilot and results in the corresponding system output:
- No output / normal state
- Slight alert and suggestion to get a coffee
- Full Master Caution Warning and wake up sounds

With having three clearly defined states, classification is assumed to be suitable for this setting.

## Feature Engineering
Our input provides 32 features: various expressions, emotions, and head orientations. We decided that the expressions and orientations are more informative than the emotions, so we have disabled the inputs "emotions.anger" and "emotions.disgust" for now, since they should not be helpful in determining if someone is asleep. 

## Choice of Algorithm

