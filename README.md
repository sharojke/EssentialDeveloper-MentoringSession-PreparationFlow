# Preparation flow
## This project is designed for a mentoring session at the Essential Developer Academy

### Project description: 
There is a feature called `hearing check` (`TestViewController`) where the user can check their hearing loss (this feature is **NOT implemented**).

To get to the feature the user has to pass a `preparation flow` (`PreparationFlow`) which is a chain of requirements that have to be satisfied:
- headphones have to be connected (`HeadphonesPreparationViewController`)
- it has to be quiet around (`LoudnessPreparationViewController`)
- the system volume has to be 50% (`SystemVolumePreparationViewController`)

After a requirement is accepeted the user gets to the next requirement. The system has to observe accepted requirements and interrupt the user in case an accepted requirement is violated. For example:
- the user accepted that the headphones have to be connected
- the user continues to the next requirement
- the headphones get disconnected
- the system has to interrupt the user showing an interruption screen

There are 3 interruptions (`PreparationInterruption`) with different priorities:
- headphones (`HeadphonesInterruptionViewController`) - high
- systemVolume (`SystemVolumeInterruptionViewController`) - medium
- loudness (`LoudnessInterruptionViewController`) - low

Additional conditions:
- if an interruption with a lower priority is presented, it has to be **IMMEDIATELY** replaced with an interruption with a higher priority
- if an interruption is satisfied, it has to be dismissed **in 2 seconds**
- all violated interruptions have to be satisfied before getting back to the preparation/test

Since we are going to use a simulator during the mentoring session, I prepared a `PermissionControlsContainerView` that can be found on ALL scenes (`UIViewController`) that stubs the satisfaction and violation behavior. 

---

### Questions:
- Threading logic:
  - How to move the threading logic to the composers using Swift Concurrency? (look for `TODO: Move to the composer`)
  - How to move the threading logic to the composition root using Swift Concurrency? (look for `TODO: Move to the composition root`)
  - What to do with the threading logic in the `PreparationFlow`? (look for `TODO: Composition root or MainQueueDispatchDecorator`)
- How to notify the interrupted scene that there is no interruptions anymore? (look for `TODO: Notify the current scene`)
- How to manage the initialization order of objects? (look for `TODO: Before initing the manager the permission has to be allowed`)
- How to make the flow bidirectional? For example:
  - the user is on the 2nd requirement + the system is observing the violation of the 1st requirement
  - the user gets back (by pressing the navigation back button)
  - the system has to stop observing the 1st accepted requirement since the user has returned
- Multiple flows:
  - Where to initialize a new flow?
  - Where to hold the reference to the flow?
  - How to remove the prev flow if it is not needed anymore?
- What is your opinion about this solution? What could be done to improve the solution?
