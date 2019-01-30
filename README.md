# Classification-PIFFS
The Pilot Fatigue Finding System (PIFFS) aims to prevent sleepiness, fatigue, and degenerating vigilance of airline pilots using a wake up alarm.

## Demo videos:
### Version 1:
https://www.youtube.com/watch?v=zLAZLwdBAfA&feature=youtu.be
### Final Version:
https://www.youtube.com/watch?v=nA-D9UScmS0&feature=youtu.be

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

In total, four different algortihms have been trained and tested for classification accuracy. The training sample did not change and included more than 500 instances. During the test, the "pilot" switched from the "Wakefulness" state to the "Drowsiness" state 10 times in a row. The same procedure was done for switching from the "Wakefulness" state to the "Sleeping" state. The detected accuracies can be seen in the Table below:

| State                      | kNN (k=1) | kNN (k=5) | Decision Tree | Adaboost (with Decision Tree) |
|----------------------------|-----------|-----------|---------------|-------------------------------|
| Wakefulness --> Drowsiness | .8        | .9        | 1.0           | 1.0                           |
| Wakefulness --> Sleepiness | 1.0       | .9        | .3            | .3                            |
| Total                      | .9        | .9        | .65           | .65                           |

From our test data it becomes obvious that Adaboost and Decision Tree have inferior performance to the kNN algortihms. For the purpose of this program it is more important to detect the more safety critical state of "Sleepiness". For this reason, the kNN (k=1) algorithm is chose over the kNN (k=5), even though they have the same total accuracy.

In addition to our classification algorithm, our final PIFFS output code contains decision-making logic that essentially treats the model's output as suggestions rather than direct instructions. By this we meen that we have established thresholds for how long a person must appear drowsy or asleep before they hear the corresponding alarm. This dramatically reduced the state flickering which is commmonly problematic in beginner classification programs like this. 

## What We Learned
For one, we learned that classification models alone can reliably detect if a person is making an expression that resembles being drowsy or asleep, but relying on that alone leads to flickery output in the real world. To fully solve our problem, we must observe that a person is behaving like they are drowsy or asleep, which requires tracking facial expressions over time. We achieved that by exploiting the rate at which our input sends OSC messages to the output (roughly 6 messages per second). Additionally, we learned:
 - How to write Processing code
 - How to use images and sounds in a Processing program
 - How to train a classification model using facial recognition input
 - How facial recognition programs express facial features as real number values
 - How to exploit OSC message send rates to produce output that depends on time (via thresholds and state detection counts)

## What We Want to Learn More About
How to train on "no input data." We wanted a fourth state for "face not visible," but our face-tracking input software stops sending OSC messages when the face moves out of frame, and we could not find a workaround. We'd also like to learn more about how to incorporate time as a component in a classification model (in case there are better ways than how we did it).
