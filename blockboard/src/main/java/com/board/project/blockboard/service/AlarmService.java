/**
 * @author Woohyeok Jun <woohyeok.jun@worksmobile.com>
 * @file AlarmService.java
 */
package com.board.project.blockboard.service;

import com.board.project.blockboard.common.util.TagCheckUtils;
import com.board.project.blockboard.dto.AlarmDTO;
import com.board.project.blockboard.dto.CommentDTO;
import com.board.project.blockboard.dto.PostDTO;
import com.board.project.blockboard.dto.UserDTO;
import com.board.project.blockboard.mapper.AlarmMapper;
import java.util.List;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@Slf4j
public class AlarmService {

  @Autowired
  private AlarmMapper alarmMapper;
  @Autowired
  private TagCheckUtils tagCheckUtils;

  public void insertAlarm(PostDTO post) {
    Set<String> taggedUsers = tagCheckUtils.getTaggedUsers(post);
    if (taggedUsers != null) {
      for (String taggedUserID : taggedUsers) {
        AlarmDTO alarm = new AlarmDTO();
        alarm.setPostID(post.getPostID());
        alarm.setTaggedUserID(taggedUserID);
        alarmMapper.insertAlarm(alarm);
      }
    }
  }

  public void insertAlarm(CommentDTO comment) {
    Set<String> taggedUsers = tagCheckUtils.getTaggedUsers(comment);
    log.info(taggedUsers.toString());
    if (taggedUsers != null) {
      for (String taggedUserID : taggedUsers) {
        AlarmDTO alarm = new AlarmDTO();
        alarm.setCommentID(comment.getCommentID());
        alarm.setPostID(comment.getPostID());
        alarm.setTaggedUserID(taggedUserID);
        alarmMapper.insertAlarm(alarm);
      }
    }
  }

  public List<AlarmDTO> selectAlarmsByUser(HttpServletRequest request) {
    UserDTO user = new UserDTO(request);
    return alarmMapper.selectAlarmsByUser(user);
  }

  public AlarmDTO selectAlarmByAlarmId(int alarmId) {
    return alarmMapper.selectAlarmByAlarmId(alarmId);
  }

  public void deleteAlarm(int alarmID) {
    alarmMapper.deleteAlarm(alarmID);
  }

  public void readAlarm(int alarmId) {
    alarmMapper.readAlarm(alarmId);
  }
}
