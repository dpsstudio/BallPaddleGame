using UnityEngine;
using System.Collections;

public class BouncingPlaneScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void OnCollisionEnter(Collision col)
	{
		if(col.gameObject.name=="RopeBall" && col.gameObject.renderer.isVisible){
			Vector3 objectScreenPos = Camera.main.WorldToViewportPoint(col.gameObject.transform.position);
			//Debug.Log(objectScreenPos.ToString());
			//If the ball is inside big rectangle on the screen then it's ok. It's made to prevent side collisions
			if(objectScreenPos.x>-0.2f && objectScreenPos.x<1.2f && objectScreenPos.y<1.2f && objectScreenPos.y>-0.2f){
				audio.Play();
				Handheld.Vibrate();			
			}
		}
	}
}
