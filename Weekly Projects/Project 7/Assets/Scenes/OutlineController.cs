using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class OutlineController : MonoBehaviour
{
    public Outline outline; // Reference to the Outline component
    private float originalOutlineWidth; // To remember the original width
    private bool isOutlineActive = false; // Track whether the outline is active

    

    void Start()
    {
       
        if (outline != null)
        {
            // Remember the original outline width
            originalOutlineWidth = outline.OutlineWidth;

            // Start with the outline turned off
            outline.OutlineWidth = 0;
        }
    }

    // Update is called once per frame
    void Update()
    {
        // Toggle the outline effect on 'E' key press
        if (Input.GetKeyDown(KeyCode.E))
        {
           
            ToggleOutline();
        }
    }

    // Toggle the outline effect
    private void ToggleOutline()
    {
        if (outline != null)
        {
            isOutlineActive = !isOutlineActive; // Toggle the state
            outline.OutlineWidth = isOutlineActive ? originalOutlineWidth : 0;
        }
    }
}
