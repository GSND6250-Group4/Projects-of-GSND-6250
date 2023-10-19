using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Infinite : MonoBehaviour
{
    // Start is called before the first frame update
    public Transform endPoint; 
    public Transform startPoint;
    public Vector3 forcedRotation = new Vector3(0, 180, 0);
    public GameObject door1;
    public GameObject door2;
    public GameObject radio;
    private bool isReadyToChange = false;

    //blood effects to spawn for loop 2
    public GameObject loop2bloodeffects;
    public bool l2beffectsActivate = false;

    //light flicker for loop 2
    public List<Light> flickeringLights = new List<Light>();
    public float minIntensity = 0.5f;
    public float maxIntensity = 1.0f;
    public float flickerSpeed = 1.0f;

    private List<float> initialIntensities = new List<float>();
    private float initialIntensity;
// end of loop 2 effects

//start of loop 3 effects
//gore effects to spawn for loop 3
    public GameObject loop3goreeffects;
    public bool l3effectsActivate = false;

    // loop 3 lighting effects
    public Light directionalLight;
    public void LoopTwo()
    {
        // Add things in loop two
        Loop2BloodActivateObject();
        StartCoroutine(FlickerLights());
        door1.SetActive(false);
       radio.SetActive(true);
    }

    public void Loop2BloodActivateObject()
    {
        if (loop2bloodeffects!= null)
            {
                 loop2bloodeffects.SetActive(true);
            }
        
    }


    public void Loop3GoreActivateObject()
    {
        if (loop3goreeffects!= null)
            {
                 loop3goreeffects.SetActive(true);
            }
        
    }

     public void ToggleObjectStatel2b()
    {
        if (loop2bloodeffects!= null)
        {
            loop2bloodeffects.SetActive(!loop2bloodeffects.activeSelf);
        }
    }

    public void LoopThree()
    {
        // Addd things in loop three
        StartCoroutine(ChangeLightColorOverTime());
        Loop3GoreActivateObject();
        Debug.Log("check for loop3 activation");
        
    }

    void Start()
    {
        GameObject hallwayObject = GameObject.Find("Infinite");

        if( loop2bloodeffects!= null)
        {
            // Set the initial state of the object based on the 'l2beffectsactivate' flag.
            loop2bloodeffects.SetActive(l2beffectsActivate);
        }
        foreach (Light light in flickeringLights)
        {
            if (light != null)
            {
                initialIntensities.Add(light.intensity);
            }
            else
            {
                Debug.LogError("A Light in the list is not assigned.");
                initialIntensities.Add(0.0f);
            }
        }

        if( loop3goreeffects!= null)
        {
            // Set the initial state of the object based on the 'l2beffectsactivate' flag.
            loop3goreeffects.SetActive(l3effectsActivate);
        }

        if (directionalLight == null)
        {
            Debug.LogError("Directional Light not assigned!");
            return;
        }

        
        
        if (hallwayObject != null)
        {
            Debug.Log("Right");
        }
        else
        {
            Debug.LogError("InfiniteHallway object not found in the scene");
        }
    }

    IEnumerator FlickerLights()
    {
        while (true)
        {
            for (int i = 0; i < flickeringLights.Count; i++)
            {
                if (flickeringLights[i] != null)
                {
                    float targetIntensity = UnityEngine.Random.Range(minIntensity, maxIntensity);

                    float t = 0;
                    while (t < 1)
                    {
                        t += Time.deltaTime * flickerSpeed;
                        flickeringLights[i].intensity = Mathf.Lerp(initialIntensities[i], targetIntensity, t);
                        yield return null;
                    }
                }
            }

            yield return new WaitForSeconds(UnityEngine.Random.Range(0.1f, 0.5f));
        }
    }

    // Update is called once per frame
    void Update()
    {
      
    }
    void OnTriggerEnter(Collider other)
    {
        Debug.Log(GameManager.instance.interactedItems);
        if (other.tag == "Player" )
        {
            Vector3 offsetPosition = other.transform.position - endPoint.position;
            other.transform.position = startPoint.position + offsetPosition;
            other.transform.rotation = Quaternion.Euler(forcedRotation);
            Debug.Log("wxxxxxxxxxxxxxxcsdffwerffffffffff");

            if (GameManager.instance.shouldChangeScene)
            {
                LoopTwo();
                GameManager.instance.shouldChangeScene = false;
            }
            if (GameManager.instance.interactedItems==5)
            {
                LoopThree();
                GameManager.instance.shouldChangeScene2 = false;
            }



        }
       
        
    /*    if (other.tag == "Player" && GameManager.instance.shouldChangeScene2)
        {
            Vector3 offsetPosition = other.transform.position - endPoint.position;
            other.transform.position = startPoint.position + offsetPosition;
            other.transform.rotation = Quaternion.Euler(forcedRotation);
            Debug.Log("wxxxxxxxxxxxxxxcsdffwerffffffffff");


            LoopThree();
            GameManager.instance.shouldChangeScene2 = false;



        }*/

        
    }

    private IEnumerator ChangeLightColorOverTime()
    {
        Color targetColor = Color.red; // The target color you want to achieve.
        float duration = 5.0f; // The duration over which the color will change.
        Color startColor = directionalLight.color; // The starting color of the light.

        float elapsedTime = 0;

        while (elapsedTime < duration)
        {
            // Interpolate the color value over time.
            Color newColor = Color.Lerp(startColor, targetColor, elapsedTime / duration);

            // Assign the new color to the light.
            directionalLight.color = newColor;

            elapsedTime += Time.deltaTime;
            yield return null;
        }

        // Ensure the light reaches the target color exactly.
        directionalLight.color = targetColor;
    }

}
