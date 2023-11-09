using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
[ExecuteInEditMode]
#endif

public class LightRays : MonoBehaviour
{
    private Light sun;
    public bool AlignWithSunDirection = true;
    //public bool GetColorFromSun = false;
    public string sunTag = "Sun";
    private MaterialPropertyBlock propertyBlock;
    private MeshRenderer meshRnr;

    void OnEnable()
    {
        propertyBlock = new MaterialPropertyBlock();
        meshRnr = GetComponent<MeshRenderer>();

        if (AlignWithSunDirection)
        {
            if (GameObject.FindGameObjectWithTag(sunTag) != null)
            {
                if (GameObject.FindGameObjectWithTag(sunTag) == null)
                    return;

                sun = GameObject.FindGameObjectWithTag(sunTag).GetComponent<Light>();
                transform.rotation = sun.transform.rotation;
                /*
                if (GetColorFromSun){
                    Color color = sun.color;
                    color.a = meshRnr.sharedMaterial.color.a;
                    propertyBlock.SetColor("_Color", color);
				}
                */
            }
        }

        float rndX = Random.Range(0f, 1f);
        float rndY = Random.Range(0f, 1f);

        //meshRnr.SetTextureOffset ("_Noise", new Vector2(rndX, rndY));
        propertyBlock.SetVector("_NoiseOffset", new Vector2(rndX, rndY));
        meshRnr.SetPropertyBlock(propertyBlock);
    }
}

