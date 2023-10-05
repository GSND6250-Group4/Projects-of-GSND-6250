using UnityEngine;

public class Destroy : MonoBehaviour
{


    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Weapon")) 
        {
            Destroy(other.gameObject); 
        }
    }
}

