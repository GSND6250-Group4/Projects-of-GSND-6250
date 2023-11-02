using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class TogglePostProcessing : MonoBehaviour
{
    public PostProcessVolume postProcessVolume;

    private void Start()
    {
        // Disable post-processing initially
        postProcessVolume.enabled = false;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.E)) // Change this key to your desired toggle key
        {
            // Toggle the post-processing effect
            postProcessVolume.enabled = !postProcessVolume.enabled;
        }
    }
}