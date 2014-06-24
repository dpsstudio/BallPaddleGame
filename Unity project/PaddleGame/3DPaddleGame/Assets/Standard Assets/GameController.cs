using UnityEngine;
using System.Collections;

public class GameController : MonoBehaviour
{

	public GameObject hitCountLabel;
	private int hitCount = 0;
	
	// Use this for initialization
	void Start ()
	{
	
	}
	
	// Update is called once per frame
	void Update ()
	{
	
	}
	
	public void OnBallHit(GameObject sender)
	{
		sender.transform.position = new Vector3(Random.Range(-5.25f,-6.25f),Random.Range(0.75f,1.5f),-6.7f);
		hitCount++;
		if(hitCountLabel!=null && hitCountLabel.GetComponent<UILabel>()!=null)
		{
			hitCountLabel.GetComponent<UILabel>().text = hitCount.ToString();
		}
	}
}

