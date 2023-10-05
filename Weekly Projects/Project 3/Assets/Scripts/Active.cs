using UnityEngine;

public class Active : MonoBehaviour
{
    public GameObject sphere;  // 拖拽你的 Sphere GameObject 到这里

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            sphere.SetActive(true);  // 启动 Sphere GameObject
        }
    }
}
