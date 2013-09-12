using UnityEngine;
using System.Collections;

public class RopeController : MonoBehaviour {
	
	public InteractiveCloth ropeCloth;
	public GameObject ropeBall;

	// Use this for initialization
	void Start () {
		
        Input.gyro.enabled = true;
        Input.compass.enabled = true;
		
		PhysicsDataManager.Instance.physicsData.LoadData();
		
		ropeBall.transform.localScale = new Vector3(PhysicsDataManager.Instance.physicsData.BallDiameter,
			PhysicsDataManager.Instance.physicsData.BallDiameter,
			PhysicsDataManager.Instance.physicsData.BallDiameter);
		
		ropeBall.rigidbody.mass = PhysicsDataManager.Instance.physicsData.BallWeight;
		
	}
	
    void Update() {
		
		Vector3 pushForce = Vector3.Scale(Input.gyro.userAcceleration * PhysicsDataManager.Instance.physicsData.BallPushForce * Time.deltaTime,new Vector3(1,1,-1));
		//Synchronize physics world gravity vector with real world gravity vector
		float gravityMultiplier = PhysicsDataManager.Instance.physicsData.Gravity * PhysicsDataManager.Instance.physicsData.CameraSensivity;
		Vector3 gravityVector = Vector3.Scale(Input.acceleration,new Vector3(gravityMultiplier,gravityMultiplier,-gravityMultiplier));
		
		//Debug.Log("Gyro attitude: " + Input.gyro.attitude);
		//Debug.Log("User acceleration: " + Input.gyro.userAcceleration);
		//Debug.Log("Acceleration: " + Input.acceleration);
		//Debug.Log("Applying force: " + pushForce);
		//GameObject.Find("GyroDirection").transform.rotation.SetLookRotation(gravityVector);//correction * gyroOrientation;
		Physics.gravity =  gravityVector;
		ropeCloth.density = GameConstants.MAX_ROPE_LENGTH - PhysicsDataManager.Instance.physicsData.MaxRopeLength;
		ropeCloth.bendingStiffness = PhysicsDataManager.Instance.physicsData.RopeTension;
		
		//Filtering noise from acceleration and detecting "push"
		if(Input.gyro.userAcceleration.magnitude>PhysicsDataManager.Instance.physicsData.CameraAcceleration) ropeBall.rigidbody.AddForce(pushForce);
		
		
	}
}
