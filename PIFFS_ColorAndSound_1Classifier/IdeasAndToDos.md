
## Ideas and ToDos:

- Make Images same size so they fully overlap when classes change. 
   - See: https://processing.org/reference/PImage.html
   - Alternatively, adjust frame size to fit images with each change
- Let's smooth the whole system. The Coffee warning should only go on if you yawn twice or three times. Class 3 should only come on if you are asleep for more than 5 seconds. The output shouldn't flick around all the time, so it's less annyoing.
   - If this is possible. The simple classifier models we're using may not allow time to be a component that factors into when classes change.
      - But, thinking about how to do this manually, instead of switching images based directly on the model's input, we could use counter variables to keep track of how many times a certain classification is detected, and only change images/sounds when, for example, the "coffee" state is detected (some reasonable number X) times during the same state. Or we could manually add some time-tracking logic in draw().
   - Experiment with different models (e.g. SVM with soft margins)
- Stop Sound when classes switch. When class 2 (Coffee!!) is present, I don't want to hear the sound from class 1
   - Probably as simple as calling SoundFile.pause(); see: https://processing.org/reference/libraries/sound/SoundFile.html
- Create case for missing Input signal from Face Recognition. If no OSC input goes through, a message and countdown should appear "Return back to your seat. Alarm will go on in 5... 4.... 3.... 2... 1...". If there is still no input after 5 (or10?) seconds, switch to the Alarm class (class 3)
   - Could start by adding a fourth class where the training input is just us outside the camera's view.
   - Again, not sure if we can actually incorportate time into this classification program (without hardcoding it ourselves in draw(); see: https://processing.org/examples/setupdraw.html)

