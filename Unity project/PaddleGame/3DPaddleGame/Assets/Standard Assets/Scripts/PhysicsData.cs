using UnityEngine;
using UnityEngineInternal;
using System;
using System.Collections;
using System.IO;
using System.Text.RegularExpressions;


using PlayerPrefs = PreviewLabs.PlayerPrefs;

public class PhysicsDataManager : Singleton<PhysicsDataManager>
{
	protected PhysicsDataManager ()
	{
	} // guarantee this will be always a singleton only - can't use the constructor!
 
	public PhysicsData physicsData;
 
	void Awake ()
	{
		physicsData = Instance.GetOrAddComponent<PhysicsData> ();
	}
}
 
public static class PhysicsDataExtension
{
	public static A GetOrAddComponent<A> (this Component child) where A: Component
	{
		A result = child.GetComponent<A> ();
		if (result == null) {
			result = child.gameObject.AddComponent<A> ();
		}
		return result;
	}

}

public class PhysicsData : Singleton<PhysicsData>
{
	/*
	protected PhysicsData ()
	{
	}
	*/

	new private static PhysicsData Instance { get { return null; } } // prevents calling Instance before Manager's Awake
 
	private float gravity;
	private Vector3 roomSize;
	private float ballDiameter;
	private float ballWeight;
	private float ballPushForce;
	private float maxRopeLength;
	private float ropeTension;
	private float cameraAcceleration;
	private float cameraSensivity;
	
	private Vector3 cameraPosByPhone = new Vector3 (GameConstants.MAX_ROOM_SIZE * 0.5f, GameConstants.MAX_ROOM_SIZE * 0.5f, GameConstants.MAX_ROOM_SIZE * 0.5f);
	
	public void LoadData()
	{
		gravity = PlayerPrefs.GetFloat("Gravity", 6.62f);
		
		ballDiameter = PlayerPrefs.GetFloat("BallDiameter", 0.75f);
		ballWeight = PlayerPrefs.GetFloat("BallWeight", 19.24f);
		ballPushForce = PlayerPrefs.GetFloat("BallPushForce", 829.6f);
		
		cameraAcceleration = PlayerPrefs.GetFloat("CameraAcceleration", 1.0f);
		cameraSensivity = PlayerPrefs.GetFloat("CameraSensivity", 0.99f);
		
		ropeTension = PlayerPrefs.GetFloat("RopeTension", 0.18f);

		maxRopeLength = PlayerPrefs.GetFloat("MaxRopeLength", 1.0f);
		
		roomSize = new Vector3(PlayerPrefs.GetFloat("RoomSizeX", 1.51f),
				PlayerPrefs.GetFloat("RoomSizeY", 1.51f),
				PlayerPrefs.GetFloat("RoomSizeZ", 1.51f));

	}
	
	public void SaveData()
	{
		PlayerPrefs.SetFloat("Gravity",gravity);
		
		PlayerPrefs.SetFloat("RoomSizeX",roomSize.x);
		PlayerPrefs.SetFloat("RoomSizeY",roomSize.y);
		PlayerPrefs.SetFloat("RoomSizeZ",roomSize.z);

		PlayerPrefs.SetFloat("BallDiameter",ballDiameter);	
		
		PlayerPrefs.SetFloat("BallWeight",ballWeight);

		PlayerPrefs.SetFloat("BallPushForce",ballPushForce);
		
		PlayerPrefs.SetFloat("MaxRopeLength", maxRopeLength);
		
		PlayerPrefs.SetFloat("RopeTension",ropeTension);

		PlayerPrefs.SetFloat("CameraAcceleration",cameraAcceleration);
		PlayerPrefs.SetFloat("CameraSensivity", cameraSensivity);
		
		PlayerPrefs.Flush();
		
		Debug.Log("Data saved");
	}
    public float Gravity
    {
        get { return gravity; }
        set 
		{
			gravity = value;
		}
    }	
	
	public Vector3 RoomSize
    {
        get { return roomSize; }
        set
		{
			roomSize = value;
		}
    }	

	
	public Vector3 CameraPosByPhone
    {
        get { return cameraPosByPhone; }
        set { cameraPosByPhone = value; }
    }	
	
	public float BallDiameter
    {
        get { return ballDiameter; }
        set
		{
			ballDiameter = value;
		}
    }	

	public float BallWeight
    {
        get { return ballWeight; }
        set
		{
			ballWeight = value;
		}
    }	

	public float BallPushForce
    {
        get { return ballPushForce; }
        set
		{
			ballPushForce = value;
		}
    }	

	public float MaxRopeLength
    {
        get { return maxRopeLength; }
        set
		{
			maxRopeLength = value;
		}
    }	

	public float RopeTension
    {
        get { return ropeTension; }
        set
		{
			ropeTension = value;
		}
    }	

	public float CameraAcceleration
    {
        get { return cameraAcceleration; }
        set
		{
			cameraAcceleration = value;
		}
    }	

	public float CameraSensivity
    {
        get { return cameraSensivity; }
        set
		{
			cameraSensivity = value;
		}
    }	
	
	
}