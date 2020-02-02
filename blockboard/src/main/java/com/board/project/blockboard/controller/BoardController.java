/**
 * @author Dongwook Kim <dongwook.kim1211@worksmobile.com>
 * @file BoardController.java
 */
package com.board.project.blockboard.controller;


import com.board.project.blockboard.dto.BoardDTO;
import com.board.project.blockboard.service.BoardService;
import com.board.project.blockboard.service.FunctionService;
import com.board.project.blockboard.service.JwtService;
import com.board.project.blockboard.service.UserService;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Slf4j
@Controller
@RequestMapping("/boards")
public class BoardController {
    @Autowired
    private BoardService boardService;
    @Autowired
    private JwtService jwtService;

    /**
     * 게시물 조회
     * @param postID
     * @param request
     * @return PostDTO + 유저일치여부 로 구성된 map
     */
    @GetMapping(value = "/{boardid}/posts/{postid}")
    @ResponseBody
    public Map<String,Object> getPostByPostID(@PathVariable("postid") int postID, HttpServletRequest request) {
        String userID = jwtService.getUserId();
        int companyID = jwtService.getCompanyId();

        //postData는 PostDTO + 유저 일치여부
        Map<String, Object> postData  = boardService.getPostDataAboutSelected(postID,userID);
        return postData;
    }

    /**
     * 게시판 목록 가져오기
     * @param request
     * @return 게시판 목록
     */
    @GetMapping(value = "")
    @ResponseBody
    public List<BoardDTO> getBoardList(HttpServletRequest request) {
        int companyID = jwtService.getCompanyId();

        //게시판 목록
        List<BoardDTO> boardList = boardService.getBoardListByCompanyID(companyID); // select로 받아오기
        return boardList;
    }

    /**
     * 게시판 추가
     * @param newBoardName 새로입력받은 보드이름
     * @param request
     */
    @PostMapping(value = "")
    @ResponseBody
    public void insertNewBoard(@RequestParam("boardName") String newBoardName, HttpServletRequest request){
        int companyID = jwtService.getCompanyId();
        //게시판 삽입
        boardService.insertNewBoard(newBoardName, companyID);
    }

    /**
     * 게시판 이름 변경 변경된 리스트를 받아와서 수정한다.
     * @param newTItleList 이름이 변경된 리스트
     * @param request
     */
    @PutMapping(value = "")
    @ResponseBody
    public void  changeNewBoardName(@RequestParam("newTitles") String newTItleList, HttpServletRequest request) {
        int companyID = jwtService.getCompanyId();
        boardService.updateChangedName(newTItleList,companyID);
    }

    /**
     * 게시판 삭제
     * @param deleteBoards 삭제리스트
     * @param request
     */
    @DeleteMapping(value = "")
    @ResponseBody
    public void deleteBoardbyBoardID(@RequestParam("deleteList") String deleteBoards, HttpServletRequest request) {
        int companyID = jwtService.getCompanyId();

        log.info("deleteBoards : "+deleteBoards);
        boardService.deleteBoardsByDeleteBoardList(companyID,deleteBoards); //기존데이터
    }

}