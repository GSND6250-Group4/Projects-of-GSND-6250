using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Platform : MonoBehaviour
{
    public GameObject fragmentPrefab;
    public float maxMoveDistance = 5f;
    public float moveSpeed = 2f;
    private bool shouldMovePlatforms = false;
    public Transform player;
    public Transform boss;
    public GameObject playerNewPosition;
    public GameObject bossNewPosition;

    private List<GameObject> fragments = new List<GameObject>();
    private bool fragmentCollected = false; 

    public Light directionalLight;


       private void Start()
    {
        // Check if the directionalLight reference is set.
        if (directionalLight == null)
        {
            Debug.LogError("Directional Light not assigned!");
            return;
        }

        // Example: Change the color of the directional light over time.
        
    }


    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) || fragmentCollected)  
        {
            StartCoroutine(ChangeLightColorOverTime());
            shouldMovePlatforms = true;
            fragmentCollected = false;  
        }

        if (shouldMovePlatforms)
        {
            MovePlatformsAndSpawnFragments();
            MovePlayerAndBoss();
        }

        CollectFragments();
    }

    void CollectFragments()
    {
        Collider[] hitColliders = Physics.OverlapSphere(player.position, 0.5f);

        foreach (var hitCollider in hitColliders)
        {
            if (hitCollider.CompareTag("Weapon") && fragments.Contains(hitCollider.gameObject))
            {
                fragments.Remove(hitCollider.gameObject);
                Destroy(hitCollider.gameObject);
                fragmentCollected = true;  
            }
        }
    }

    void MovePlatformsAndSpawnFragments()
    {
        int fragmentCount = 0;

        foreach (Transform child in transform)
        {
            float targetHeight = child.position.y + Random.Range(1f, maxMoveDistance);
            child.position = Vector3.Lerp(child.position, new Vector3(child.position.x, targetHeight, child.position.z), Time.deltaTime * moveSpeed);

            if (fragmentCount < 20 && Random.value < 0.5f)
            {
                Vector3 spawnPosition = new Vector3(child.position.x, child.position.y + 5f, child.position.z);
                var newFragment = Instantiate(fragmentPrefab, spawnPosition, Quaternion.identity, child);
                fragments.Add(newFragment);  
                fragmentCount++;
            }
        }

        shouldMovePlatforms = false;
    }

    void MovePlayerAndBoss()
    {
        player.position = playerNewPosition.transform.position;
        boss.position = bossNewPosition.transform.position;

        BossShoot bossShoot = boss.GetComponent<BossShoot>();
        if (bossShoot != null)
        {
            bossShoot.StartShooting();
        }
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
