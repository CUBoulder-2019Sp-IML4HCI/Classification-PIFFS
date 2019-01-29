# Classification-PIFFS
The Pilot Fatigue Finding System (PIFFS) aims to prevent sleepiness, fatigue, and degenerating vigilance of airline pilots using a wake up alarm.

## Demo videos:
### Version 1:
https://www.youtube.com/watch?v=zLAZLwdBAfA&feature=youtu.be
### Final Version:
TBA

## Functional Goal
The goal of the Pilot Fatigue Finding System (PIFFS) is to prevent sleepiness, fatigue and degenerating vigilance of airline transport pilots. During prolonged cruise flights, pilots are prone to falling asleep. PIFFS aims to detect three states of fatigue using facial recognition technology. Once a severe state of fatigue, or even worse, sleep, is detected, the system responds with an alarming sound and a text message, prompting the pilot to regain attention and situational awareness.

## Running the code
PIFFS was written for compatibility with Wekinator. To run it, first ensure that you have downloaded Wekinator, then clone this repo onto your local machine. Open Wekinator, and configure it to recieve 32 inputs and to produce one classification output with 3 classes (or alternatively, load up a pre-trained model from the `saved models` folder). You then need to open the input and output. The input facial recognition program is AffdexMe-OSC.app; if you are using a Mac, using that app should be as simple as double clicking it in your local copy of this repo. If that doesn't work, there is a README inside the app with further instructions. There are two output choices: our first output, the Processing code found in `PIFFS_ColorAndSound_1Classifier` which contains only bare bones functionality, and the Processing code found in `PIFFS_Max_Shawn_Final` which is the second and final version of PIFFS output. Once Wekinator, the input, and the output are open and running, train the system (if not using a pre-trained model) by showing Wekinator examples of your face while awake (for state 1), examples of your face looking drowsy (for state 2), and examples of your face looking asleep (for state 3), then run the model. 

## Why Classification is Useful
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
Our input provides 32 features: various expressions, emotions, and head orientations. We decided that the expressions and orientations are more informative than the emotions, so we have disabled all `emotions.*` inputs. We originally thought that a select few facial features like how closed the eyes are or how tilted the head is would be optimal at differentiating our three states (wakefullness, drowsiness, sleep), but we learned that relying on so few of our 32 inputs led to severe overfitting. The human face is nuanced when behaving drowsily and keeping more input features led to a more reliable model. 

## Choice of Algorithm
So far, we are quite happy with the classification accuracy that the kNN algorithm (with k=1) provided us after just 349 training samples. In a second iteration, we trained the same dataset with a decision tree. But since no restrictions to the depth of the tree can be specified in Wekinator, the decision tree overfits the training sample. This becomes evident in the test runs: The alarm does not sound unless the face and eye positions exactly match the test instances.
**TODO: numerical evidence of overfitting**
In addition to our classification algorithm, our final PIFFS output code contains decision-making logic that essentially treats the model's output as suggestions rathan than direct instructions. By this we meen that we have established thresholds for how long a person must appear drowsy or asleep before they hear the corresponding alarm. This dramatically reduced the state flickering which is commmonly problematic in beginner classification programs like this. 

## What We Learned
For one, we learned that classification models alone can reliably detect if a person is _making an expression that resembles_ being drowsy or asleep, but relying on that alone leads to flickery output in the real world. To fully solve our problem, we must observe that a person is _behaving like_ they are drowsy or asleep, which requires tracking facial expressions over time. We achieved that by exploiting the rate at which our input sends OSC messages to the output (roughly 6 messages per second). Additionally, we learned:
 - How to write Processing code
 - How to use images and sounds in a Processing program
 - How to train a classification model using facial recognition input
 - How facial recognition programs express facial features as real number values
 - How to exploit OSC message send rates to produce output that depends on time (via thresholds and state detection counts)

## What We Want to Learn More About
How to train on "no input data." We wanted a fourth state for "face not visible," but our face-tracking input software stops sending OSC messages when the face moves out of frame, and we could not find a workaround. We'd also like to learn more about how to incorporate time as a component in a classification model (in case there are better ways than how we did it).
