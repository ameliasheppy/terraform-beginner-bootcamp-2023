## Switch back to TF Cloud

### No vars worked
After adding cloud back into our main.tf to move our state mgmt to TF Cloud instead of locally, we were having errors with var locations. We went into the settings of our project in TF Cloud and set our Execution Mode to local. 

### Vars still being declared invalid
Since we have set up a new workflow, we need to accomplish update with GitOps. We will commit and push our changes, then TF Cloud will regsiter the changes, plan them, and apply them. 

### Does TF Cloud Run Environment dowload the whole codebase when it uses VCS? <--- A musing by Andrew and Chris
Can we reference files in the Run Env? If you check 'HCL' in the TF Vars, we can interpolate at runtime. 

## Real World TF byChris
Companies don't have devs running tf init, plan, and apply locally. GitOps is set up so that each commit will trigger a tf apply. GitOps means you make a change to Iac and the change is propagated through GH, to TF, and applies into your env. 