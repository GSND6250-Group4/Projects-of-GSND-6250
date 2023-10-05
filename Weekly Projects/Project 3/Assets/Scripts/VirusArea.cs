using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VirusArea : MonoBehaviour
{
    public float maxScale = 5f;
    public float growthRate = 0.1f;
    private bool shouldGrow = false;
    private Transform sphereTransform;
    public Light directionalLight2;

    void Start()
    {
        sphereTransform = transform; 
        sphereTransform.gameObject.SetActive(true); 
        if (directionalLight2 == null)
        {
            Debug.LogError("Directional Light not assigned!");
            return;
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            StartCoroutine(ChangeLightColorOverTime());
            shouldGrow = true;
        }

        if (shouldGrow && sphereTransform.localScale.x < maxScale)
        {
            Vector3 newScale = sphereTransform.localScale + Vector3.one * growthRate * Time.deltaTime;
            newScale = new Vector3(Mathf.Min(newScale.x, maxScale), Mathf.Min(newScale.y, maxScale), Mathf.Min(newScale.z, maxScale)); 
            sphereTransform.localScale = newScale; 
        }
    }
    private IEnumerator ChangeLightColorOverTime()
    {
        Color targetColor = Color.green; // The target color you want to achieve.
        float duration = 5.0f; // The duration over which the color will change.
        Color startColor = directionalLight2.color; // The starting color of the light.

        float elapsedTime = 0;

        while (elapsedTime < duration)
        {
            // Interpolate the color value over time.
            Color newColor = Color.Lerp(startColor, targetColor, elapsedTime / duration);

            // Assign the new color to the light.
            directionalLight2.color = newColor;

            elapsedTime += Time.deltaTime;
            yield return null;
        }

        // Ensure the light reaches the target color exactly.
        directionalLight2.color = targetColor;
    }
}
