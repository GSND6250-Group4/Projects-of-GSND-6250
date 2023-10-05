using System.Collections;
using UnityEngine;

public class BossShoot : MonoBehaviour
{
    public GameObject bulletPrefab;
    public float shootInterval = 50f; 

    public Transform player;

    private void Start()
    {
        StartShooting();  // This will start shooting when the game object becomes active
    }

    public void StartShooting()
    {
        StartCoroutine(ShootAtPlayer());
    }

    IEnumerator ShootAtPlayer()
    {
        while (true)
        {
            GameObject bullet = Instantiate(bulletPrefab, transform.position, Quaternion.identity);
            bullet.GetComponent<HomingBullet>().target = player;
            yield return new WaitForSeconds(shootInterval);
        }
    }
}
