using UnityEngine;

public class Highlight : MonoBehaviour
{
    public Outline outline;
    public GameObject ui;

    private bool isNear = false;
    private bool isUIActive = false;
    private bool canInteract = true;  // 添加一个变量来控制物品是否可以被交互

    void Start()
    {
        if (ui == null || outline == null)
        {
            Debug.LogError("UI or Outline is not set");
            return;
        }

        ui.SetActive(false);
        outline.enabled = false;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player") && canInteract) // 检查 canInteract 变量
        {
            outline.enabled = true;
            isNear = true;
            Debug.Log("Player is near");
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            outline.enabled = false;
            isNear = false;
            Debug.Log("Player left");
        }
    }

    void Update()
    {
        if (isNear && Input.GetKeyDown(KeyCode.E) && canInteract)
        {
            isUIActive = !isUIActive;
            ui.SetActive(isUIActive);
           
            if (!isUIActive)
            {
                canInteract = false;
                outline.enabled = false;
                // 通知 GameManager 物品被交互
                GameManager.instance.ItemInteracted();

            }
        }
    }

}
